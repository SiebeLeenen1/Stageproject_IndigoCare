#
# Copyright (C) 2018 Lucian Cristian <lucian.cristian@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=frr5
PKG_VERSION:=5.0.2
PKG_RELEASE:=12

PKG_SOURCE_VERSION:=5.0.2
PKG_SOURCE=frr-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/FRRouting/frr/releases/download/frr-$(PKG_SOURCE_VERSION)/
PKG_HASH:=4cf5416e6e6eebdd3be61f76d1de7bede87521af3f2ac4b3fb9713837458aaff
PKG_LICENSE_FILES:=COPYING

PKG_CONFIG_DEPENDS:= \
	CONFIG_IPV6 \
	CONFIG_PACKAGE_frr5-babeld \
	CONFIG_PACKAGE_frr5-bgpd \
	CONFIG_PACKAGE_frr5-eigrpd \
	CONFIG_PACKAGE_frr5-isisd \
	CONFIG_PACKAGE_frr5-ldpd \
	CONFIG_PACKAGE_frr5-libfrr \
	CONFIG_PACKAGE_frr5-nhrp \
	CONFIG_PACKAGE_frr5-ospfd \
	CONFIG_PACKAGE_frr5-ospf6d \
	CONFIG_PACKAGE_frr5-pbrd \
	CONFIG_PACKAGE_frr5-pimd \
	CONFIG_PACKAGE_frr5-ripd \
	CONFIG_PACKAGE_frr5-ripngd \
	CONFIG_PACKAGE_frr5-vtysh \
	CONFIG_PACKAGE_frr5-watchfrr \
	CONFIG_PACKAGE_frr5-zebra

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_BUILD_DEPENDS:=frr/host
HOST_BUILD_DEPENDS:=elfutils/host
PKG_LICENSE:=GPL-2.0-only

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

define Package/frr5/Default
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Routing and Redirection
  TITLE:=The FRRouting (FRR) Software Routing Suite
  URL:=https://www.frrouting.org/
  MAINTAINER:=Lucian Cristian <lucian.cristian@gmail.com>
  DEPENDS:=frr5
endef

define Package/frr5
  $(call Package/frr5/Default)
  DEPENDS:=+librt
  TITLE:=The FRRouting (FRR) Software Routing Suite
  MENU:=1
endef

define Package/frr5/description
  FRRouting is free software that implements and manages various IPv4 and IPv6
  routing protocols.

  Currently FRRouting supports BGP4, BGP4+, OSPFv2, OSPFv3, RIPv1, RIPv2, RIPng,
  IS-IS, PIM-SM/MSDP, LDP and Babel as well as very early support for EIGRP and
  NHRP.
endef

define Package/frr5-babeld
  $(call Package/frr5/Default)
  DEPENDS+=+frr5-libfrr
  TITLE:=BABEL daemon
endef

define Package/frr5-bgpd
  $(call Package/frr5/Default)
  DEPENDS+=+frr5-libfrr +frr5 +frr5-watchfrr +frr5-zebra +kmod-tcpmd5sig
  TITLE:=BGPv4, BGPv4+, BGPv4- daemon
endef

define Package/frr5-eigrpd
  $(call Package/frr5/Default)
  DEPENDS+=+frr5 +frr5-libfrr +frr5-watchfrr +frr5-zebra
  TITLE:=EIGRP daemon
endef

define Package/frr5-isisd
  $(call Package/frr5/Default)
  DEPENDS+=+frr5-libfrr
  TITLE:=IS-IS daemon
endef

define Package/frr5-ldpd
  $(call Package/frr5/Default)
  DEPENDS+=+frr5-libfrr
  TITLE:=LDP daemon
endef

define Package/frr5-libfrr
  $(call Package/frr5/Default)
  TITLE:=zebra library
  DEPENDS+=+libatomic +libjson-c
endef

define Package/frr5-nhrp
  $(call Package/frr5/Default)
  DEPENDS+=+frr5 +frr5-libfrr +libcares +frr5-watchfrr +frr5-zebra
  TITLE:=NHRP daemon
endef

define Package/frr5-ospfd
  $(call Package/frr5/Default)
  DEPENDS+=+frr5 +frr5-libfrr +frr5-watchfrr +frr5-zebra
  TITLE:=OSPFv2 daemon
endef

define Package/frr5-ospf6d
  $(call Package/frr5/Default)
  DEPENDS+=+frr5-libfrr @IPV6
  TITLE:=OSPFv3 daemon
endef

define Package/frr5-pbrd
  $(call Package/frr5/Default)
  DEPENDS+=+frr5-libfrr
  TITLE:=PBRD daemon
endef

define Package/frr5-pimd
  $(call Package/frr5/Default)
  DEPENDS+=+frr5-libfrr
  TITLE:=PIM daemon
endef

define Package/frr5-ripd
  $(call Package/frr5/Default)
  DEPENDS+=+frr5 +frr5-libfrr +frr5-watchfrr +frr5-zebra
  TITLE:=RIP daemon
endef

define Package/frr5-ripngd
  $(call Package/frr5/Default)
  DEPENDS+=+frr5-libfrr @IPV6
  TITLE:=RIPNG daemon
endef

define Package/frr5-vtysh
  $(call Package/frr5/Default)
  DEPENDS+=+frr5-libfrr +libreadline +libncurses
  TITLE:=integrated shell for frr routing software
endef

define Package/frr5-watchfrr
  $(call Package/frr5/Default)
  TITLE:=frr watchdog
  DEPENDS+=+frr5-libfrr
  DEFAULT:=y if PACKAGE_frr
endef

define Package/frr5-zebra
  $(call Package/frr5/Default)
  TITLE:=Zebra daemon
  DEPENDS+=+frr5-libfrr
  DEFAULT:=y if PACKAGE_frr
endef

# define Package/frr5-babeld/conffiles
# /etc/frr/babeld.conf
# endef

define Package/frr5-bgpd/conffiles
/etc/config/bgp
endef

define Package/frr5-eigrpd/conffiles
/etc/config/eigrp
endef

# define Package/frr5-isisd/conffiles
# /etc/frr/isisd.conf
# endef

define Package/frr5-ldpd/conffiles
/etc/config/mpls
endef

define Package/frr5-nhrp/conffiles
/etc/config/nhrp
endef

define Package/frr5-ospfd/conffiles
/etc/config/ospf
endef

# define Package/frr5-ospf6d/conffiles
# /etc/frr/ospf6d.conf
# endef

# define Package/frr5-pbrd/conffiles
# /etc/frr/pbrd.conf
# endef

# define Package/frr5-pimd/conffiles
# /etc/frr/pimd.conf
# endef

define Package/frr5-ripd/conffiles
/etc/config/rip
endef

# define Package/frr5-ripngd/conffiles
# /etc/frr/ripngd.conf
# endef

# define Package/frr5-ripngd/conffiles
# /etc/frr/vtysh.conf
# endef

define Build/Configure
    ( cd $(PKG_BUILD_DIR)/ ; \
    mkdir build/ ; \
    cd build ; \
    ../configure \
    	PYTHON_CFLAGS="-I/usr/include/ncursesw -I/usr/include/ncurses" \
	--host="$(GNU_TARGET_NAME)" \
	--build="$(GNU_HOST_NAME)" \
	CFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS) -DFALSE=0 -DTRUE=1" \
	CXXFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS) $(EXTRA_LDFLAGS)" \
	HOST_CFLAGS="$(HOST_CFLAGS)" \
	HOST_LDFLAGS="$(HOST_LDFLAGS)" \
	BUILD_CPPFLAGS="$(TARGET_CPPLAGS)" \
	BUILD_CFLAGS="$(TARGET_CFLAGS)" \
	BUILD_LDFLAGS="$(TARGET_LDFLAGS)" \
	--localstatedir=/var/run/frr \
	--sysconfdir=/etc/frr/ \
	--enable-shared \
	--disable-static \
	--enable-user=root \
	--enable-group=root \
	--enable-multipath=8 \
	--with-vtysh-pager=cat \
	--disable-capabilities \
	--disable-ospfclient \
	--disable-doc \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-babeld,babeld) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-bgpd,bgpd) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-eigrpd,eigrpd) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-isisd,isisd) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-ldpd,ldpd) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-nhrp,nhrp) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-ospfd,ospfd) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-ospf6d,ospf6d) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-pbrd,pbrd) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-pimd,pimd) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-ripd,ripd) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-ripngd,ripngd) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-vtysh,vtysh) \
	$(call autoconf_bool,CONFIG_PACKAGE_frr5-libfrr,zebra) \
)
endef

#	just speed it up, maybe not a good approach ?
#NUM_CORES ?= $(shell grep -c "vendor_id" /proc/cpuinfo)

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/build
endef

define Package/frr5/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/frr $(1)/usr/sbin/frr.init
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/frr.init $(1)/etc/init.d/frr
	$(INSTALL_DIR) $(1)/etc/uci-defaults/7.5
	$(CP) ./files/defaults/97_frr_indexing $(1)/etc/uci-defaults/7.5/97_frr_indexing
	$(CP) ./files/defaults/98_modify-frr.sh $(1)/etc/uci-defaults/7.5/98_modify-frr.sh
	$(CP) ./files/defaults/99_migrate-frr.sh $(1)/etc/uci-defaults/7.5/99_migrate-frr.sh
endef

define Package/frr5-watchfrr/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/watchfrr/.libs/watchfrr $(1)/usr/sbin/
endef

define Package/frr5-zebra/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/zebra/.libs/zebra $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_DATA) ./files/zebra.conf $(1)/etc/frr/
endef

define Package/frr5-babeld/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/babeld/.libs/babeld $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/babeld.conf
endef

define Package/frr5-bgpd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/bgpd/.libs/bgpd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/bgpd.conf
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/configs/bgp.conf $(1)/etc/config/bgp
endef

define Package/frr5-bgpd/prerm
	#!/bin/sh
	. /lib/functions.sh
	config_load frr || exit 0
	uci_remove frr bgp
	uci_remove frr main_instance
	uci_add frr bgp_general bgp
	uci_add frr bgp_instance main_instance
	uci_commit frr
endef

define Package/frr5-eigrpd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/eigrpd/.libs/eigrpd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/eigrpd.conf
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/configs/eigrp.conf $(1)/etc/config/eigrp
endef

define Package/frr5-eigrpd/prerm
	#!/bin/sh
	. /lib/functions.sh
	config_load frr || exit 0
	uci_remove frr eigrp
	uci_add frr eigrp_general eigrp
	uci_commit frr
endef

define Package/frr5-isisd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/isisd/.libs/isisd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/isisd.conf
endef

define Package/frr5-ldpd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/ldpd/.libs/ldpd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/ldpd.conf
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/configs/mpls.conf $(1)/etc/config/mpls
endef

define Package/frr5-nhrp/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/nhrpd/.libs/nhrpd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/nhrpd.conf
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/configs/nhrp.conf $(1)/etc/config/nhrp
endef

define Package/frr5-nhrp/prerm
	#!/bin/sh
	. /lib/functions.sh
	clean_config() {
		uci_remove frr "$$1"
	}
	config_load frr || exit 0
	config_foreach clean_config nhrp_instance
	uci_remove frr nhrp
	uci_add frr nhrp_general nhrp
	uci_commit frr
endef

define Package/frr5-ospfd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/ospfd/.libs/ospfd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/ospfd.conf
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/configs/ospf.conf $(1)/etc/config/ospf
endef

define Package/frr5-ospfd/prerm
	#!/bin/sh
	. /lib/functions.sh
	clean_config() {
		uci_remove frr "$$1"
	}
	config_load frr || exit 0
	config_foreach clean_config ospf_area
	config_foreach clean_config ospf_network
	config_foreach clean_config ospf_interface
	uci_remove frr ospf
	uci_add frr ospf ospf
	uci_commit frr
endef

define Package/frr5-ospf6d/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/ospf6d/.libs/ospf6d $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/ospf6d.conf
endef

define Package/frr5-pbrd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/pbrd/.libs/pbrd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/pbrd.conf
endef

define Package/frr5-pimd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/pimd/.libs/pimd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/pimd.conf
endef

define Package/frr5-ripd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/ripd/.libs/ripd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/ripd.conf
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/configs/rip.conf $(1)/etc/config/rip
endef

define Package/frr5-ripd/prerm
	#!/bin/sh
	. /lib/functions.sh
	clean_config() {
		uci_remove frr "$$1"
	}
	config_load frr || exit 0
	config_foreach clean_config interface
	config_foreach clean_config rip_access_list
	uci_remove frr rip
	uci_add frr rip_general rip
	uci_commit frr
endef

define Package/frr5-ripngd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/ripngd/.libs/ripngd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/frr.conf $(1)/etc/frr/ripngd.conf
endef

define Package/frr5-vtysh/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/vtysh/.libs/vtysh $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/frr
	chmod 0750 $(1)/etc/frr
	$(INSTALL_CONF) ./files/vtysh.conf $(1)/etc/frr/vtysh.conf
endef

define Package/frr5-libfrr/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/build/lib/.libs/libfrr.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,frr5))
$(eval $(call BuildPackage,frr5-babeld))
$(eval $(call BuildPackage,frr5-bgpd))
$(eval $(call BuildPackage,frr5-eigrpd))
$(eval $(call BuildPackage,frr5-isisd))
$(eval $(call BuildPackage,frr5-ldpd))
$(eval $(call BuildPackage,frr5-libfrr))
$(eval $(call BuildPackage,frr5-nhrp, +iptables-mod-hashlimit +iptables-mod-nflog))
$(eval $(call BuildPackage,frr5-ospfd))
$(eval $(call BuildPackage,frr5-ospf6d))
$(eval $(call BuildPackage,frr5-pbrd))
$(eval $(call BuildPackage,frr5-pimd))
$(eval $(call BuildPackage,frr5-ripd))
$(eval $(call BuildPackage,frr5-ripngd))
$(eval $(call BuildPackage,frr5-vtysh))
$(eval $(call BuildPackage,frr5-watchfrr))
$(eval $(call BuildPackage,frr5-zebra))
