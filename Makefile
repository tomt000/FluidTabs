#FluidTabs by TomT000 © 2019

THEOS_DEVICE_IP=192.168.1.29

INSTALL_TARGET_PROCESSES = #SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FluidTabs

FluidTabs_FILES = FluidTabs.x
FluidTabs_FRAMEWORKS = UIKit
FluidTabs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += fluidtabs
include $(THEOS_MAKE_PATH)/aggregate.mk
