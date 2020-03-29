.PHONY : check_env build build_arm64 build_debug_arm64 package package_arm64 app app_arm64 app_debug_arm64 build_buckdebug build_verbose kill_xcode clean project project_buckdebug temp

include Makefile.Utils

BUCK_OPTIONS=\
	--config custom.appVersion="5.14.1" \
	--config custom.developmentCodeSignIdentity="${DEVELOPMENT_CODE_SIGN_IDENTITY}" \
	--config custom.distributionCodeSignIdentity="${DISTRIBUTION_CODE_SIGN_IDENTITY}" \
	--config custom.developmentTeam="${DEVELOPMENT_TEAM}" \
	--config custom.baseApplicationBundleId="${BUNDLE_ID}" \
	--config custom.apiId="${API_ID}" \
	--config custom.apiHash="${API_HASH}" \
	--config custom.hockeyAppId="${HOCKEYAPP_ID}" \
	--config custom.isInternalBuild="${IS_INTERNAL_BUILD}" \
	--config custom.isAppStoreBuild="${IS_APPSTORE_BUILD}" \
	--config custom.appStoreId="${APPSTORE_ID}" \
	--config custom.appSpecificUrlScheme="${APP_SPECIFIC_URL_SCHEME}" \
	--config custom.buildNumber="${BUILD_NUMBER}" \
	--config custom.entitlementsApp="${ENTITLEMENTS_APP}" \
	--config custom.developmentProvisioningProfileApp="${DEVELOPMENT_PROVISIONING_PROFILE_APP}" \
	--config custom.distributionProvisioningProfileApp="${DISTRIBUTION_PROVISIONING_PROFILE_APP}" \
	--config custom.entitlementsExtensionNotificationService="${ENTITLEMENTS_EXTENSION_NOTIFICATIONSERVICE}" \
	--config custom.developmentProvisioningProfileExtensionNotificationService="${DEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONSERVICE}" \
	--config custom.distributionProvisioningProfileExtensionNotificationService="${DISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONSERVICE}" \
	--config custom.entitlementsExtensionNotificationContent="${ENTITLEMENTS_EXTENSION_NOTIFICATIONCONTENT}" \
	--config custom.developmentProvisioningProfileExtensionNotificationContent="${DEVELOPMENT_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONCONTENT}" \
	--config custom.distributionProvisioningProfileExtensionNotificationContent="${DISTRIBUTION_PROVISIONING_PROFILE_EXTENSION_NOTIFICATIONCONTENT}"

# Use local version of Buck
BUCK=@tools/buck
 
build: check_env
	$(BUCK) build //Apps/TicTacToe:AppBundle \
	${BUCK_OPTIONS} ${BUCK_DEBUG_OPTIONS} ${BUCK_THREADS_OPTIONS} ${BUCK_CACHE_OPTIONS}

build_buckdebug: check_env
	BUCK_DEBUG_MODE=1 $(BUCK) build //Apps/TicTacToe:AppBundle \
	${BUCK_OPTIONS} ${BUCK_DEBUG_OPTIONS} ${BUCK_THREADS_OPTIONS} ${BUCK_CACHE_OPTIONS}

build_release: check_env
	$(BUCK) build //Apps/TicTacToe:AppBundle \
	${BUCK_OPTIONS} ${BUCK_RELEASE_OPTIONS} ${BUCK_THREADS_OPTIONS} ${BUCK_CACHE_OPTIONS}

test: check_env
	$(BUCK) test \
	//Apps/... \
	//Libraries/... \
	${BUCK_OPTIONS} ${BUCK_DEBUG_OPTIONS} ${BUCK_THREADS_OPTIONS} ${BUCK_CACHE_OPTIONS}

deps: check_env
	$(BUCK) query "deps(//Apps/TicTacToe:AppPackage)" --dot  \
	${BUCK_OPTIONS} ${BUCK_DEBUG_OPTIONS}

targets: check_env
	$(BUCK) targets //Libraries/TicTacToeRib/...  \
	${BUCK_OPTIONS} ${BUCK_DEBUG_OPTIONS}

clean: kill_xcode
	rm -rf **/*.xcworkspace
	rm -rf **/*.xcodeproj
	rm -rf buck-out

project: check_env kill_xcode
	$(BUCK) project //Apps:AllWorkspace --config custom.mode=project ${BUCK_OPTIONS} ${BUCK_DEBUG_OPTIONS}
	open Apps/All.xcworkspace

project_opt: check_env kill_xcode
	$(BUCK) project //Apps:AllWorkspace --config custom.mode=project ${BUCK_OPTIONS} ${BUCK_RELEASE_OPTIONS}
	open Apps/All.xcworkspace

project_buckdebug: check_env kill_xcode
	BUCK_DEBUG_MODE=1 $(BUCK) project //Apps:AllWorkspace --config custom.mode=project ${BUCK_OPTIONS} ${BUCK_DEBUG_OPTIONS}
	open Apps/All.xcworkspace
