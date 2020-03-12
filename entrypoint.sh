#!/usr/bin/env bash

# Be strict
set -e
set -u
set -o pipefail

awsDir="${HOME}/.aws"
config="${awsDir}/config"
credentials="${awsDir}/credentials"

mkdir -p "${awsDir}"

echo -e "[profile default]\noutput = json" >> "$config"
tokendito --aws-profile default -ou $INPUT_OKTA_APP_URL -R $INPUT_AWS_ROLE_ARN --username $INPUT_OKTA_USERNAME --password $INPUT_OKTA_PASSWORD --mfa-method ${INPUT_OKTA_MFA_METHOD:=token:software:totp} --mfa-response `echo $INPUT_OKTA_MFA_SEED | mintotp` >> /dev/null

# mv "${CREDS_DIR}" "${GITHUB_WORKSPACE}"
# # since we can't write to runner's home, export these vars so that AWS CLI can find the files
# # https://github.community/t5/GitHub-Actions/Docker-action-can-t-create-folder-in-runner-s-home-directory/m-p/49612
# echo "::set-env name=AWS_CONFIG_FILE::${INPUT_WORKSPACE}/.aws/config"
# echo "::set-env name=AWS_SHARED_CREDENTIALS_FILE::${INPUT_WORKSPACE}/.aws/credentials"

# Read credentials
section=
while read -r line; do
    # Get section we are currently in
    if [[ "${line}" =~ ^[[:space:]]*\[[-_.a-zA-Z0-9]+\][[:space:]]*$ ]]; then
        section="${line%]}"
        section="${section#[}"
    fi
    # Extract available aws export values
    if [ "${section}" = "default" ]; then
        if [[ "${line}" =~ ^[[:space:]]*aws_access_key_id[[:space:]]*=.*$ ]]; then
            echo "::set-env name=AWS_ACCESS_KEY_ID::${line##*=*[[:space:]]}"
            echo "::add-mask::$AWS_ACCESS_KEY_ID"
        fi
        if [[ "${line}" =~ ^[[:space:]]*aws_secret_access_key[[:space:]]*=.*$ ]]; then
            echo "::set-env name=AWS_SECRET_ACCESS_KEY::${line##*=*[[:space:]]}"
            echo "::add-mask::$AWS_SECRET_ACCESS_KEY"
        fi
        if [[ "${line}" =~ ^[[:space:]]*aws_session_token[[:space:]]*=.*$ ]]; then
            echo "::set-env name=AWS_SESSION_TOKEN::${line##*=*[[:space:]]}"
            echo "::add-mask::$AWS_SESSION_TOKEN"
        fi
    fi
done < "$credentials"
