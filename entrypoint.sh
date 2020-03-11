#!/usr/bin/env bash

# Be strict
set -e
set -u
set -o pipefail

printenv

CREDS_DIR="${HOME}/.aws"
mkdir -p "${CREDS_DIR}"
echo "[profile ${INPUT_AWS_PROFILE:-default}]\noutput = json" >> "${CREDS_DIR}/config"
tokendito --config-file "${CREDS_DIR}/config" -ou $INPUT_OKTA_APP_URL -R $INPUT_AWS_ROLE_ARN --username $INPUT_OKTA_USERNAME --password $INPUT_OKTA_PASSWORD --mfa-method ${INPUT_OKTA_MFA_METHOD:-token:software:totp} --mfa-response `echo $INPUT_OKTA_MFA_SEED | mintotp` -o "${CREDS_DIR}/credentials" >> /dev/null

# mv "${CREDS_DIR}" "${GITHUB_WORKSPACE}"
# # since we can't write to runner's home, export these vars so that AWS CLI can find the files
# # https://github.community/t5/GitHub-Actions/Docker-action-can-t-create-folder-in-runner-s-home-directory/m-p/49612
# echo "::set-env name=AWS_CONFIG_FILE::${INPUT_WORKSPACE}/.aws/config"
# echo "::set-env name=AWS_SHARED_CREDENTIALS_FILE::${INPUT_WORKSPACE}/.aws/credentials"

# Extract value from string (Format: NAME = VALUE)
get_val() {
    local line="${1}"
    echo "${line##*=*[[:space:]]}"
}

# Read credentials
section=
while read -r line; do
    # Get section we are currently in
    if [[ "${line}" =~ ^[[:space:]]*\[[-_.a-zA-Z0-9]+\][[:space:]]*$ ]]; then
        section="${line%]}"
        section="${section#[}"
    fi
    # Extract available aws export values
    if [ "${section}" = "${INPUT_AWS_PROFILE}" ]; then
        if [[ "${line}" =~ ^[[:space:]]*aws_access_key_id[[:space:]]*=.*$ ]]; then
            aws_access_key_id="$( get_val "${line}" )"
        fi
        if [[ "${line}" =~ ^[[:space:]]*aws_secret_access_key[[:space:]]*=.*$ ]]; then
            aws_secret_access_key="$( get_val "${line}" )"
        fi
        if [[ "${line}" =~ ^[[:space:]]*aws_session_token[[:space:]]*=.*$ ]]; then
            aws_session_token="$( get_val "${line}" )"
        fi
    fi
done < "${CREDS_DIR}/credentials"

# Output exports
if [ -n "${aws_access_key_id}" ]; then
    echo "::set-env name=AWS_ACCESS_KEY_ID::${aws_access_key_id}"
fi
if [ -n "${aws_secret_access_key}" ]; then
    echo "::set-env name=AWS_SECRET_ACCESS_KEY::${aws_secret_access_key}"
fi
if [ -n "${aws_session_token}" ]; then
    echo "::set-env name=AWS_SESSION_TOKEN::${aws_session_token}"
fi
