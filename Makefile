include $(THEOS)/makefiles/common.mk

FindFiles = $(foreach ext, c cpp m mm x xm xi xmi, $(wildcard $(1)/*.$(ext)))

TWEAK_NAME = LaunchInSafeMode
LaunchInSafeMode_FILES = Source/Classes/LaunchInSafeModeTweak.m $(call FindFiles, Source/Hooks)

SUBPROJECTS += Source/PreferenceBundle

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
