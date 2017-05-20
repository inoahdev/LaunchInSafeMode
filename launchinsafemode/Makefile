include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LaunchInSafeMode
LaunchInSafeMode_FILES = LaunchInSafeModeRootListController.m
LaunchInSafeMode_INSTALL_PATH = /Library/PreferenceBundles
LaunchInSafeMode_FRAMEWORKS = UIKit
LaunchInSafeMode_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LaunchInSafeMode.plist$(ECHO_END)
