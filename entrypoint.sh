#!/bin/sh

mkdir ~/.aws
echo "[profile $1]\noutput = json" >> ~/.aws/config
mfa_response=`oathtool -b --totp $6`
tokendito -ou $5 -R $2 --username $3 --password $4 --mfa-method $7 --mfa-response $mfa_response >> /dev/null
