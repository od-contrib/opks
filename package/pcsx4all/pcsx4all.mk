################################################################################
#
# pcsx4all
#
################################################################################
PCSX4ALL_VERSION = a2ae76c6f1
PCSX4ALL_SITE = $(call github,tonyjih,RG350_pcsx4all,$(PCSX4ALL_VERSION))
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
  LD="$(TARGET_CXX)" \
  GCC_NEW=1

define PCSX4ALL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(PCSX4ALL_MAKE_OPTS) -C $(@D) -f Makefile.$(PCSX4ALL_PLATFORM)
endef

define PCSX4ALL_INSTALL_OPK_IMAGES
	cd $(@D) && ./make_opk.sh
	$(INSTALL) -D -m 0644 $(@D)/pcsx4all.opk $(BINARIES_DIR)/opks/
endef
PCSX4ALL_POST_INSTALL_TARGET_HOOKS += PCSX4ALL_INSTALL_OPK_IMAGES

$(eval $(generic-package))
