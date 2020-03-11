#!/bin/sh

# Inspired from https://github.com/cytopia/aws-export-profile

# Input parameter
PROFILE="${INPUT_AWS_PROFILE:-default}"
CREDENTIALS="${2:-${HOME}/.aws/credentials}"
CONFIG="${3:-${HOME}/.aws/config}"

# Available values in credentials file
aws_access_key_id=
aws_secret_access_key=
aws_session_token=

# Test if credentials file is found, otherwise abort
if [ ! -f "${CREDENTIALS}" ]; then
	printf "Error, credentials file does not exist: %s\n" "${CREDENTIALS}"
	exit 1
fi

# Test if config file is found, otherwise no export of region is available
if [ ! -f "${CONFIG}" ]; then
	printf "Warning, config file does not exist: %s\n" "${CONFIG}" >&2
fi

# Trim whitespace
trim() {
	local line="${1}"
	line="${line#"${line%%[![:space:]]*}"}"
	line="${line%"${line##*[![:space:]]}"}"
	echo "${line}"
}

# Extract value from string (Format: NAME = VALUE)
get_val() {
	local line="${1}"
	echo "${line##*=*[[:space:]]}"
}

# Read region
if [ -f "${CONFIG}" ]; then
	section=
	while read -r line; do
		# Get section we are currently in
		if [[ "${line}" =~ ^[[:space:]]*\[profile[[:space:]]+[-_.a-zA-Z0-9]+\][[:space:]]*$ ]]; then
			section="${line%]}"
			section="${section#[profile}"
			section="$( trim "${section}" )"
		fi
	done < "${CONFIG}"
fi

# Read credentials
section=
while read -r line; do
	# Get section we are currently in
	if [[ "${line}" =~ ^[[:space:]]*\[[-_.a-zA-Z0-9]+\][[:space:]]*$ ]]; then
		section="${line%]}"
		section="${section#[}"
	fi
	# Extract available aws export values
	if [ "${section}" = "${PROFILE}" ]; then
		if [[ "${line}" =~ ^[[:space:]]*aws_access_key_id[[:space:]]*=.*$ ]]; then
			aws_access_key_id="$( get_val "${line}" )"
		fi
		if [[ "${line}" =~ ^[[:space:]]*aws_secret_access_key[[:space:]]*=.*$ ]]; then
			aws_secret_access_key="$( get_val "${line}" )"
		fi
		if [[ "${line}" =~ ^[[:space:]]*aws_session_token[[:space:]]*=.*$ ]]; then
			aws_session_token="$( get_val "${line}" )"
		fi
		if [[ "${line}" =~ ^[[:space:]]*aws_security_token[[:space:]]*=.*$ ]]; then
			aws_security_token="$( get_val "${line}" )"
		fi
	fi
done < "${CREDENTIALS}"

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
