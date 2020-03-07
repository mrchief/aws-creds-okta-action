#!/bin/sh

mkdir ~/.aws
echo "[profile $INPUT_AWS_PROFILE]\noutput = json" >> ~/.aws/config
mfa_response=`echo $INPUT_OKTA_MFA_SEED | mintotp`
tokendito -ou $INPUT_OKTA_APP_URL -R $INPUT_AWS_ROLE_ARN --username $INPUT_OKTA_USERNAME --password $INPUT_OKTA_PASSWORD --mfa-method $INPUT_OKTA_MFA_METHOD --mfa-response $mfa_response >> /dev/null
