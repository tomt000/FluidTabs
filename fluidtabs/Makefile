include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FluidTabs

FluidTabs_FILES = FTRootListController.m Banner.mm
FluidTabs_INSTALL_PATH = /Library/PreferenceBundles
FluidTabs_FRAMEWORKS = UIKit
FluidTabs_PRIVATE_FRAMEWORKS = Preferences
FluidTabs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FluidTabs.plist$(ECHO_END)
