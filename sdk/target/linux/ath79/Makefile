include $(TOPDIR)/rules.mk

ARCH:=mips
BOARD:=ath79
BOARDNAME:=Atheros ATH79
SUBTARGETS:=24kc

FEATURES:=squashfs reset_button

KERNEL_PATCHVER:=5.4

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += swconfig tc-tiny

$(eval $(call BuildTarget))
