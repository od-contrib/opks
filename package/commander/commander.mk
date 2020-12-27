################################################################################
#
# DinguxCommander
#
################################################################################

COMMANDER_VERSION = e5f008a
COMMANDER_SITE = $(call github,od-contrib,commander,$(COMMANDER_VERSION))
COMMANDER_DEPENDENCIES = sdl sdl_gfx sdl_image sdl_ttf

COMMANDER_TARGET_PLATFORM ?= $(call qstrip,$(BR2_PACKAGE_COMMANDER_TARGET_PLATFORM))

ifeq ($(BR2_TARGET_PLATFORM),"rg350")
COMMANDER_TARGET_PLATFORM=rg350
COMMANDER_OPK_EXT=gcw0
else ifeq ($(BR2_TARGET_PLATFORM),"gcw0")
COMMANDER_TARGET_PLATFORM=gcw0
else ifeq ($(BR2_TARGET_PLATFORM),"rs90")
COMMANDER_TARGET_PLATFORM=rs90
else ifeq ($(BR2_TARGET_PLATFORM),"retrofw")
COMMANDER_TARGET_PLATFORM=retrofw
else
$(error No platform mapping for $(BR2_TARGET_PLATFORM))
endif

ifeq ($(COMMANDER_OPK_EXT),)
COMMANDER_OPK_EXT=$(COMMANDER_TARGET_PLATFORM)
endif

COMMANDER_CONF_OPTS += \
	-DWITH_SYSTEM_SDL_GFX=ON -DWITH_SYSTEM_SDL_TTF=OFF \
	-DTARGET_PLATFORM=$(COMMANDER_TARGET_PLATFORM) \
	-DFONTS=$(BR2_PACKAGE_COMMANDER_FONTS) \
	-DLOW_DPI_FONTS=$(BR2_PACKAGE_COMMANDER_FONTS_LOW_DPI) \
	-DRES_DIR=""

ifneq ($(BR2_TARGET_DEVICE),"rg350m")
COMMANDER_CONF_OPTS += -DWITH_SYSTEM_SDL_TTF=ON
endif

ifeq ($(BR2_PACKAGE_COMMANDER_AUTOSCALE),y)
COMMANDER_CONF_OPTS += -DAUTOSCALE=1
endif

ifneq ($(BR2_PACKAGE_COMMANDER_PPU_X),"")
COMMANDER_CONF_OPTS += -DPPU_X=$(BR2_PACKAGE_COMMANDER_PPU_X)
endif

ifneq ($(BR2_PACKAGE_COMMANDER_PPU_Y),"")
COMMANDER_CONF_OPTS += -DPPU_Y=$(BR2_PACKAGE_COMMANDER_PPU_Y)
endif

ifneq ($(BR2_PACKAGE_COMMANDER_WIDTH),"")
COMMANDER_CONF_OPTS += -DSCREEN_WIDTH=$(BR2_PACKAGE_COMMANDER_WIDTH)
endif

ifneq ($(BR2_PACKAGE_COMMANDER_HEIGHT),"")
COMMANDER_CONF_OPTS += -DSCREEN_HEIGHT=$(BR2_PACKAGE_COMMANDER_HEIGHT)
endif

ifeq ($(BR2_PACKAGE_COMMANDER_OPK_NAME),"")
COMMANDER_OPK_NAME = commander-$(COMMANDER_TARGET_PLATFORM)
else
COMMANDER_OPK_NAME = $(BR2_PACKAGE_COMMANDER_OPK_NAME)
endif

define COMMANDER_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/opks
	cd $(@D) && mksquashfs \
	  "opkg/default.$(COMMANDER_OPK_EXT).desktop" \
	  "opkg/readme.$(COMMANDER_OPK_EXT).txt" \
	  opkg/commander.png \
	  res/*.png \
	  res/Fiery_Turk.ttf \
	  "$(COMMANDER_BUILDDIR)/commander" \
	  "$(BINARIES_DIR)/opks/$(COMMANDER_OPK_NAME).opk" \
	  -all-root -no-xattrs -noappend -no-exports
endef

$(eval $(cmake-package))
