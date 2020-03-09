#!/bin/sh

mkdir /github/home/.aws
echo "[profile ${INPUT_AWS_PROFILE:-default}]\noutput = json" >> /github/home/.aws/config
tokendito -ou $INPUT_OKTA_APP_URL -R $INPUT_AWS_ROLE_ARN --username $INPUT_OKTA_USERNAME --password $INPUT_OKTA_PASSWORD --mfa-method ${INPUT_OKTA_MFA_METHOD:-token:software:totp} --mfa-response `echo $INPUT_OKTA_MFA_SEED | mintotp` -o /github/home/.aws/credentials >> /dev/null
