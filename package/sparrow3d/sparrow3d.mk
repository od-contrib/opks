################################################################################
#
# sparrow3d
#
# A build dependency of glutexto, not installed to target.
################################################################################

SPARROW3D_VERSION = 77dc9acc01
SPARROW3D_SITE = $(call github,theZiz,sparrow3d,$(SPARROW3D_VERSION))

SPARROW3D_TARGET_PLATFORM ?= $(call qstrip,$(BR2_PACKAGE_SPARROW3D_TARGET_PLATFORM))

ifeq ($(BR2_TARGET_PLATFORM),"rg350")
SPARROW3D_TARGET_PLATFORM=rg350
SPARROW3D_OPK_EXT=gcw0
else ifeq ($(BR2_TARGET_PLATFORM),"gcw0")
SPARROW3D_TARGET_PLATFORM=gcw
else
$(error No platform mapping for $(BR2_TARGET_PLATFORM))
endif

define SPARROW3D_BUILD_CMDS
	$(MAKE) TARGET=$(SPARROW3D_TARGET_PLATFORM) $(TARGET_MAKE_ENV) \
	  AR="$(TARGET_AR)" CC="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" \
	  LIB="-L$(STAGING_DIR)/usr/lib -Wl,-rpath=$(STAGING_DIR)/usr/lib" \
	  INCLUDE="-I$(STAGING_DIR)/usr/include" \
	  SDL="-I$(STAGING_DIR)/usr/include/SDL -D_GNU_SOURCE=1 -D_REENTRANT" \
	  -C $(@D)
endef

$(eval $(generic-package))
