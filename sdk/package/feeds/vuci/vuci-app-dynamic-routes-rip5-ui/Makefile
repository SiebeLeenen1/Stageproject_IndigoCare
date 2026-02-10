include $(TOPDIR)/rules.mk

APP_TITLE:=VuCI UI Support Dynamic routes rip application

ifeq (m, $(CONFIG_PACKAGE_vuci-app-dynamic-routes-rip5-ui))
	APP_APP_NAME:=frr5-ripd
	APP_TLT_NAME:= RIP daemon
	APP_ROUTER:=$(TLT_PLATFORM_NAME)
endif

include ../app.mk

define Package/vuci-app-dynamic-routes-rip5-ui/description
	The Routing Information Protocol (RIP) is one of the
	oldest distance-vector routing protocols which employ
	the hop count as a routing metric.
endef

# call BuildPackage - OpenWrt buildroot signature
