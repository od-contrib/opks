################################################################################
#
# pcsx4all
#
################################################################################
PCSX4ALL_VERSION = 21084ac
PCSX4ALL_SITE = $(call github,gameblabla,pcsx4all,$(PCSX4ALL_VERSION))
PCSX4ALL_AUTORECONF = YES
PCSX4ALL_INSTALL_STAGING = YES

ifeq ($(BR2_TARGET_PLATFORM),"rg350")
PCSX4ALL_PLATFORM=gcw0
else ifeq ($(BR2_TARGET_PLATFORM),"gcw0")
PCSX4ALL_PLATFORM=gcw0
else
$(error No platform mapping for $(BR2_TARGET_PLATFORM))
endif

PCSX4ALL_MAKE_OPTS = \
  MD="mkdir -p" \
  CC="$(TARGET_CC)" \
  CXX="$(TARGET_CXX)" \
  LD="$(TARGET_CXX)"

# BEGIN hacks for older buildroot
# Remove -flto
# Remove -mframe-header-opt and replace with -std=c99
# Add -lpthread -lrt
define PCSX4ALL_PREPARE_BUILD
	(cd $(@D) ; \
	 sed -i 's/-flto//g' Makefile.$(PCSX4ALL_PLATFORM) ; \
	 sed -i 's/-mframe-header-opt/-std=c99/g' Makefile.$(PCSX4ALL_PLATFORM) ; \
	 sed -i 's/LDFLAGS = /LDFLAGS = -lpthread -lrt /g' Makefile.$(PCSX4ALL_PLATFORM))
endef
PCSX4ALL_PRE_CONFIGURE_HOOKS += PCSX4ALL_PREPARE_BUILD
# END hacks

define PCSX4ALL_BUILD_CMDS
	$(MAKE) $(TARGET_MAKE_ENV) $(PCSX4ALL_MAKE_OPTS) -C $(@D) -f Makefile.$(PCSX4ALL_PLATFORM)
endef

define PCSX4ALL_INSTALL_OPK_IMAGES
	cd $(@D) && ./make_opk.sh
	$(INSTALL) -D -m 0644 $(@D)/pcsx4all.opk $(BINARIES_DIR)/opks/
endef
PCSX4ALL_POST_INSTALL_TARGET_HOOKS += PCSX4ALL_INSTALL_OPK_IMAGES

$(eval $(generic-package))
