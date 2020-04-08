################################################################################
#
# DinguxCommander
#
################################################################################

COMMANDER_VERSION = 7ea0831
COMMANDER_SITE = $(call github,od-contrib,commander,$(COMMANDER_VERSION))
COMMANDER_DEPENDENCIES = sdl sdl_gfx sdl_image sdl_ttf

COMMANDER_TARGET_PLATFORM ?= $(call qstrip,$(BR2_PACKAGE_COMMANDER_TARGET_PLATFORM))

ifeq ($(BR2_TARGET_PLATFORM),"rg350")
COMMANDER_TARGET_PLATFORM=rg350
else ifeq ($(BR2_TARGET_PLATFORM),"gcw0")
COMMANDER_TARGET_PLATFORM=gcw0
else ifeq ($(BR2_TARGET_PLATFORM),"retrofw")
COMMANDER_TARGET_PLATFORM=rs90
else ifeq ($(BR2_TARGET_PLATFORM),"retrofw")
COMMANDER_TARGET_PLATFORM=retrofw
else
$(error No platform mapping for $(BR2_TARGET_PLATFORM))
endif

COMMANDER_CONF_OPTS += \
	-DTARGET_PLATFORM=$(COMMANDER_TARGET_PLATFORM) \
	-DWITH_SYSTEM_SDL_TTF=ON \
	-DWITH_SYSTEM_SDL_GFX=ON

define COMMANDER_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/opks
	cd $(@D) && ./package-opk.sh $(COMMANDER_TARGET_PLATFORM) $(COMMANDER_BUILDDIR) \
	  $(BINARIES_DIR)/opks/commander-$(COMMANDER_TARGET_PLATFORM).opk
endef

$(eval $(cmake-package))
