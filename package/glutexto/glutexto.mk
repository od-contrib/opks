################################################################################
#
# glutexto
#
################################################################################

GLUTEXTO_VERSION = 79e1498207
GLUTEXTO_SITE = $(call github,theZiz,glutexto,$(GLUTEXTO_VERSION))
GLUTEXTO_DEPENDENCIES = sdl sdl_ttf sdl_mixer sdl_image sparrow3d

GLUTEXTO_TARGET_PLATFORM ?= $(call qstrip,$(BR2_PACKAGE_GLUTEXTO_TARGET_PLATFORM))

ifeq ($(BR2_TARGET_PLATFORM),"rg350")
GLUTEXTO_TARGET_PLATFORM=rg350
GLUTEXTO_OPK_EXT=gcw0
else ifeq ($(BR2_TARGET_PLATFORM),"gcw0")
GLUTEXTO_TARGET_PLATFORM=gcw
else
$(error No platform mapping for $(BR2_TARGET_PLATFORM))
endif

ifeq ($(GLUTEXTO_OPK_EXT),)
GLUTEXTO_OPK_EXT=$(GLUTEXTO_TARGET_PLATFORM)
endif

define GLUTEXTO_BUILD_CMDS
	$(MAKE) TARGET=$(GLUTEXTO_TARGET_PLATFORM) $(TARGET_MAKE_ENV) \
	  AR="$(TARGET_AR)" CC="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" \
	  LIB="-L$(STAGING_DIR)/usr/lib -Wl,-rpath=$(STAGING_DIR)/usr/lib -L$(SPARROW3D_BUILDDIR)/build/$(BR2_TARGET_PLATFORM)/sparrow3d" \
	  INCLUDE="-I$(STAGING_DIR)/usr/include -I$(SPARROW3D_BUILDDIR)" \
	  SDL="-I$(STAGING_DIR)/usr/include/SDL -D_GNU_SOURCE=1 -D_REENTRANT" \
	  SPARROW_FOLDER=$(SPARROW3D_BUILDDIR) \
	  -C $(@D)
endef

define GLUTEXTO_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/opks
	rm -rf $(@D)/pkg-tmp
	mkdir -p $(@D)/pkg-tmp/glutexto
	cp -r $(@D)/font $(@D)/pkg-tmp/glutexto/
	cp -r $(@D)/data $(@D)/pkg-tmp/glutexto/
	cp $(@D)/build/$(GLUTEXTO_TARGET_PLATFORM)/glutexto/* $(@D)/README.md $(@D)/LICENSE $(@D)/pkg-tmp/glutexto/
	cp $(@D)/build/gcw/* $(@D)/pkg-tmp/
	cd $(@D)/pkg-tmp/ && mksquashfs * "$(BINARIES_DIR)/opks/glutexto.opk" \
	  -all-root -noappend -no-exports -no-xattrs
endef

$(eval $(generic-package))
