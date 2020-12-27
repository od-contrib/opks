################################################################################
#
# blockattack
#
################################################################################

BLOCKATTACK_VERSION = 72287ac
BLOCKATTACK_SITE = $(call github,blockattack,blockattack-game,$(BLOCKATTACK_VERSION))
BLOCKATTACK_DEPENDENCIES += sdl2 sdl2_image sdl2_ttf sdl2_mixer boost physfs gettext

ifeq ($(BR2_TARGET_PLATFORM),"rg350")
else ifeq ($(BR2_TARGET_PLATFORM),"gcw0")
else
$(error No platform mapping for $(BR2_TARGET_PLATFORM))
endif

BLOCKATTACK_CONF_OPTS += \
  -DCMAKE_CXX_FLAGS="-I$(STAGING_DIR)/usr/include/utf8cpp" \
  -DCMAKE_EXE_LINKER_FLAGS=-lintl \
  -DBoost_USE_STATIC_LIBS=ON \
  -DSTANDALONE=ON -DINSTALL_DATA_DIR=. -DCMAKE_INSTALL_PREFIX=/

BLOCKATTACK_INSTALL_TARGET_OPTS = DESTDIR=./opk install

define BLOCKATTACK_PACK_DATA
	cd $(@D) && ./packdata.sh
endef
BLOCKATTACK_PRE_BUILD_HOOKS += BLOCKATTACK_PACK_DATA

define BLOCKATTACK_CLEAN_OPK_DIR
	rm -rf $(@D)/opk/
endef
BLOCKATTACK_PRE_INSTALL_TARGET_HOOKS += BLOCKATTACK_CLEAN_OPK_DIR

define BLOCKATTACK_PACKAGE_OPK
	cp $(BR2_EXTERNAL_OD_CONTRIB_OPKS_PATH)/package/blockattack/default.gcw0.desktop \
	  $(BR2_EXTERNAL_OD_CONTRIB_OPKS_PATH)/package/blockattack/blockattack32.png \
	  $(@D)/opk/
	mkdir -p $(BINARIES_DIR)/opks
	rm -f $(BINARIES_DIR)/opks/blockattack.opk
	cd $(@D)/opk && mksquashfs * $(BINARIES_DIR)/opks/blockattack.opk -noappend -no-exports -no-xattrs
endef
BLOCKATTACK_POST_INSTALL_TARGET_HOOKS += BLOCKATTACK_PACKAGE_OPK

$(eval $(cmake-package))
