#!/bin/sh

printenv

CREDS_DIR="~/.aws"
mkdir $CREDS_DIR
echo "[profile ${INPUT_AWS_PROFILE:-default}]\noutput = json" >> $CREDS_DIR/config
tokendito -ou $INPUT_OKTA_APP_URL -R $INPUT_AWS_ROLE_ARN --username $INPUT_OKTA_USERNAME --password $INPUT_OKTA_PASSWORD --mfa-method ${INPUT_OKTA_MFA_METHOD:-token:software:totp} --mfa-response `echo $INPUT_OKTA_MFA_SEED | mintotp` -o $CREDS_DIR/credentials >> /dev/null

mv $CREDS_DIR $GITHUB_WORKSPACE
# since we can't write to runner's home, export these vars so that AWS CLI can find the files
# https://github.community/t5/GitHub-Actions/Docker-action-can-t-create-folder-in-runner-s-home-directory/m-p/49612
echo "::set-env name=AWS_CONFIG_FILE::$INPUT_WORKSPACE/.aws/config"
echo "::set-env name=AWS_SHARED_CREDENTIALS_FILE::$INPUT_WORKSPACE/.aws/credentials"
