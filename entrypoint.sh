#!/usr/bin/env bash

# Be strict
set -e
set -u
set -o pipefail

CREDS_DIR="${HOME}/.aws"
mkdir -p "${CREDS_DIR}"
echo "[profile ${INPUT_AWS_PROFILE:=default}]\noutput = json" >> "${CREDS_DIR}/config"
tokendito --config-file "${CREDS_DIR}/config" -ou $INPUT_OKTA_APP_URL -R $INPUT_AWS_ROLE_ARN --username $INPUT_OKTA_USERNAME --password $INPUT_OKTA_PASSWORD --mfa-method ${INPUT_OKTA_MFA_METHOD:=token:software:totp} --mfa-response `echo $INPUT_OKTA_MFA_SEED | mintotp` -o "${CREDS_DIR}/credentials" >> /dev/null

cat "${CREDS_DIR}/config"
cat "${CREDS_DIR}/credentials"

# mv "${CREDS_DIR}" "${GITHUB_WORKSPACE}"
# # since we can't write to runner's home, export these vars so that AWS CLI can find the files
# # https://github.community/t5/GitHub-Actions/Docker-action-can-t-create-folder-in-runner-s-home-directory/m-p/49612
# echo "::set-env name=AWS_CONFIG_FILE::${INPUT_WORKSPACE}/.aws/config"
# echo "::set-env name=AWS_SHARED_CREDENTIALS_FILE::${INPUT_WORKSPACE}/.aws/credentials"

# Read credentials
section=
while read -r line; do
    echo $line
    # Get section we are currently in
    if [[ "${line}" =~ ^[[:space:]]*\[[-_.a-zA-Z0-9]+\][[:space:]]*$ ]]; then
        section="${line%]}"
        section="${section#[}"
    fi
    # Extract available aws export values
    if [ "${section}" = "${INPUT_AWS_PROFILE}" ]; then
        if [[ "${line}" =~ ^[[:space:]]*aws_access_key_id[[:space:]]*=.*$ ]]; then
            echo "::set-env name=AWS_ACCESS_KEY_ID::${line##*=*[[:space:]]}"
        fi
        if [[ "${line}" =~ ^[[:space:]]*aws_secret_access_key[[:space:]]*=.*$ ]]; then
            echo "::set-env name=AWS_SECRET_ACCESS_KEY::${line##*=*[[:space:]]}"
        fi
        if [[ "${line}" =~ ^[[:space:]]*aws_session_token[[:space:]]*=.*$ ]]; then
            echo "::set-env name=AWS_SESSION_TOKEN::${line##*=*[[:space:]]}"
        fi
    fi
done < "${CREDS_DIR}/credentials"
