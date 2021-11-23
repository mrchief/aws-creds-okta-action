# 1.4.5 - 23-11-2021
## Changes

### Bug Fixes
    
- workflow syntax

### Chores

- fix dockerhub tagging

# 1.4.4 - 23-11-2021

## Chores

- publish to docker hub as well

# 1.4.3 - 9-11-2021
### Bug Fixes
    
- action name to match repo name 🐛

# 1.4.2 - 8-11-2021

## Chores

- update docker image name to match action

# 1.4.1 - 5-11-2021
### Bug Fixes
    
- correctly output semver from build step

# 1.4.0 - 5-11-2021

## Chores

- Update changelog and manifest ([#26](https://github.com/mrchief/aws-creds-okta/issues26))

## Changes

### Features
    
- export pre-built docker image

# 1.4.0 - 5-11-2021
### Features
    
- use semver on docker image

# 1.3.0 - 5-11-2021
### Features
    
- export pre-built docker image

# 1.2.0 - 21-9-2021
### Features
    
- handle mfa token race condition ([#22](https://github.com/mrchief/aws-creds-okta/issues22))

# 1.1.5 - 19-8-2021

## Features

- [#17](https://github.com/mrchief/aws-creds-okta/issues17) - Write aws config file to a temporary directory ([#20](https://github.com/mrchief/aws-creds-okta/issues20))

# 1.1.4 - 8-6-2021
### Bug Fixes
    
- Pin tokendito version ([#15](https://github.com/mrchief/aws-creds-okta/issues15))

# 1.1.3 - 9-10-2020
### Bug Fixes
    
- replace set-env with env file ([#13](https://github.com/mrchief/aws-creds-okta/issues13))

# 1.1.2 - 23-6-2020
### Bug Fixes
    
- Do not break lines since it causes intermittent errors ([#11](https://github.com/mrchief/aws-creds-okta/issues11))

# 1.1.1 - 19-6-2020
### Bug Fixes
    
- Retry tokendito only on errors due to used totp code ([#9](https://github.com/mrchief/aws-creds-okta/issues9))

# 1.1.0 - 11-6-2020
### Features
    
- Add retry logic for requesting okta credentials ([#5](https://github.com/mrchief/aws-creds-okta/issues5))

# 1.0.0 - 12-3-2020

## Changes

### Features

- Export temporary credentials as environment variables for subsequent steps
