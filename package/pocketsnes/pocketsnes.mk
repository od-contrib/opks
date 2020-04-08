################################################################################
#
# PocketSNES
#
################################################################################
POCKETSNES_VERSION = 1a627d8
POCKETSNES_SITE = $(call github,soarqin,PocketSNES,$(POCKETSNES_VERSION))
POCKETSNES_AUTORECONF = YES
POCKETSNES_INSTALL_STAGING = YES

ifeq ($(BR2_TARGET_PLATFORM),"rg350")
else ifeq ($(BR2_TARGET_PLATFORM),"gcw0")
else
$(error No platform mapping for $(BR2_TARGET_PLATFORM))
endif

define POCKETSNES_BUILD_CMDS
	$(MAKE) $(TARGET_MAKE_ENV) CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D) all
endef

define POCKETSNES_INSTALL_OPK_IMAGES
	cd $(@D) && opk/make_opk.sh
	mkdir -p $(BINARIES_DIR)/opks
	cp -f $(@D)/opk/PocketSNES.opk $(BINARIES_DIR)/opks
endef
POCKETSNES_POST_INSTALL_TARGET_HOOKS += POCKETSNES_INSTALL_OPK_IMAGES


$(eval $(generic-package))
