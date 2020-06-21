################################################################################
#
# devilutionx
#
################################################################################

DEVILUTIONX_VERSION = f66339a
DEVILUTIONX_SITE = $(call github,diasurgical,devilutionx,$(DEVILUTIONX_VERSION))
DEVILUTIONX_DEPENDENCIES = sdl sdl_mixer sdl_image sdl_ttf

ifeq ($(BR2_TARGET_PLATFORM),"rg350")
DEVILUTIONX_TARGET_PLATFORM=rg350
else ifeq ($(BR2_TARGET_PLATFORM),"gcw0")
DEVILUTIONX_TARGET_PLATFORM=rg350
else ifeq ($(BR2_TARGET_PLATFORM),"retrofw")
DEVILUTIONX_TARGET_PLATFORM=retrofw
else
$(error No platform mapping for $(BR2_TARGET_PLATFORM))
endif

DEVILUTIONX_CONF_OPTS += \
	-DTARGET_PLATFORM=$(DEVILUTIONX_TARGET_PLATFORM) \
	-DBINARY_RELEASE=ON \
	-DVERSION_NUM=1.0.1 -DVERSION_SUFFIX="-$(DEVILUTIONX_VERSION)"

define DEVILUTIONX_INSTALL_TARGET_CMDS
	mkdir -p $(@D)/build-$(DEVILUTIONX_TARGET_PLATFORM)/
	cp $(@D)/devilutionx $(@D)/build-$(DEVILUTIONX_TARGET_PLATFORM)/
	cd $(@D) && Packaging/OpenDingux/package-opk.sh $(DEVILUTIONX_TARGET_PLATFORM)
	$(INSTALL) -D -m 0644 $(@D)/build-$(DEVILUTIONX_TARGET_PLATFORM)/devilutionx-$(DEVILUTIONX_TARGET_PLATFORM).opk \
	  $(BINARIES_DIR)/opks/
endef

$(eval $(cmake-package))
