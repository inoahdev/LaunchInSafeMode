include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LaunchInSafeMode
LaunchInSafeMode_FILES = Tweak.x

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

SUBPROJECTS += launchinsafemode

after-install::
	install.exec "killall -9 SpringBoard"
