#!/bin/bash

export TICTACTOE_ENV_SET="1"

export DEVELOPMENT_CODE_SIGN_IDENTITY="iPhone Distribution: Digital Fortress LLC (C67CF9S4VU)"
export DISTRIBUTION_CODE_SIGN_IDENTITY="iPhone Distribution: Digital Fortress LLC (C67CF9S4VU)"
export DEVELOPMENT_TEAM="C67CF9S4VU"

export API_ID="8"
export API_HASH="7245de8e747a0d6fbe11f7cc14fcc0bb"

export BUNDLE_ID="me.sangdong.TicTacToe"
export IS_INTERNAL_BUILD="true"
export IS_APPSTORE_BUILD="false"
export APPSTORE_ID="686449807"
export APP_SPECIFIC_URL_SCHEME="tictactoe"

export BUILD_NUMBER="1"

if [ -z "$BUILD_NUMBER" ]; then
	echo "BUILD_NUMBER is not defined"
	exit 1
fi

export ENTITLEMENTS_APP="TicTacToe/TicTacToe-iOS-AppStoreLLC.entitlements"
export DEVELOPMENT_PROVISIONING_PROFILE_APP="Xcode Managed Profile"
export DISTRIBUTION_PROVISIONING_PROFILE_APP="Xcode Managed Profile"

$@
