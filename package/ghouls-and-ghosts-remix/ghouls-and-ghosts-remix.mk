################################################################################
#
# Ghouls 'n Ghosts Remix - GNG
#
################################################################################
GHOULS_AND_GHOSTS_REMIX_VERSION = e5054399
GHOULS_AND_GHOSTS_REMIX_SITE = $(call github,podulator,ggr_056,$(GHOULS_AND_GHOSTS_REMIX_VERSION))
GHOULS_AND_GHOSTS_REMIX_DEPENDENCIES = allegro

ifeq ($(BR2_TARGET_PLATFORM),"rg350")
GHOULS_AND_GHOSTS_REMIX_TARGET_PLATFORM=rg-350
else ifeq ($(BR2_TARGET_PLATFORM),"gcw0")
GHOULS_AND_GHOSTS_REMIX_TARGET_PLATFORM=rg-350
else
$(error No platform mapping for $(BR2_TARGET_PLATFORM))
endif

GHOULS_AND_GHOSTS_REMIX_MAKE_OPTS = \
	MD="mkdir -p" \
	CROSS_COMPILE="$(TARGET_CROSS)"

define GHOULS_AND_GHOSTS_REMIX_BUILD_CMDS
	$(MAKE) $(TARGET_MAKE_ENV) $(GHOULS_AND_GHOSTS_REMIX_MAKE_OPTS) -C $(@D) all \
	  -f Makefile.$(GHOULS_AND_GHOSTS_REMIX_TARGET_PLATFORM)
endef

define GHOULS_AND_GHOSTS_REMIX_INSTALL_OPK_IMAGES
	cd $(@D) && ./make_opk.sh
	$(INSTALL) -D -m 0644 $(@D)/*.opk $(BINARIES_DIR)/opks/
endef
GHOULS_AND_GHOSTS_REMIX_POST_INSTALL_TARGET_HOOKS += GHOULS_AND_GHOSTS_REMIX_INSTALL_OPK_IMAGES

$(eval $(generic-package))
