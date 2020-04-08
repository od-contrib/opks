################################################################################
#
# FB Alpha
#
################################################################################

FB_ALPHA_VERSION = e4f7c3b9d3
FB_ALPHA_SITE = $(call github,nobk,fba-sdl,$(FB_ALPHA_VERSION))
FB_ALPHA_DEPENDENCIES = sdl sdl_image zlib

define FB_ALPHA_BUILD_CMDS
	$(TARGET_MAKE_ENV) MAKELEVEL=0 $(MAKE1) -C $(@D) -f Makefile.dingux
endef

define FB_ALPHA_INSTALL_TARGET_CMDS
	cd $(@D)/bin && mksquashfs skin fbasdl.dge skin/fba_icon.png default.gcw0.desktop fba_explorer.gcw0.desktop fba-rg350.opk -all-root -no-xattrs -noappend -no-exports
	$(INSTALL) -m 0644 -D $(@D)/bin/fba-rg350.opk $(BINARIES_DIR)/opks/
endef

$(eval $(generic-package))
