include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

KERNEL_LOADADDR = 0x80060000

DEVICE_VARS += UBOOT_SIZE
DEVICE_VARS += CONFIG_SIZE
DEVICE_VARS += ART_SIZE NO_ART
DEVICE_VARS += MASTER_IMAGE_SIZE

define Build/append-tlt-uboot
  dd if="$(BIN_DIR)/u-boot_$(word 1,$(DEVICE_BOOT_NAME))$(word 1,$(1)).bin" >> $@
endef

define Build/append-tlt-config
  dd if=$(TOPDIR)/target/linux/ath79/image/bin/tlt-factory-config.bin >> $@
endef

define Build/append-tlt-art
  if [ $(NO_ART) == 1 ]; then \
    dd if=/dev/zero bs=$(ART_SIZE) count=1 >> $@; \
  elif [ "$(DEVICE_MODEL)" == "TCR1XX" ]; then \
    dd if=$(TOPDIR)/target/linux/ath79/image/bin/tlt-factory-art-TCR1XX.bin >> $@; \
  else \
    dd if=$(TOPDIR)/target/linux/ath79/image/bin/tlt-factory-art.bin >> $@; \
  fi
endef

define Device/Default
  DEVICE_VENDOR := TELTONIKA
  DEVICE_DTS_DIR := ../dts
  DEVICE_DTS = $$(SOC)_$(1)
  DEVICE_FEATURES := small_flash sw-offload reset_button
  PROFILES = Default
  MTDPARTS :=
  BLOCKSIZE := 64k
  KERNEL := kernel-bin | append-dtb | lzma | uImage lzma
  KERNEL_INITRAMFS := kernel-bin | append-dtb | lzma | uImage lzma
  COMPILE :=
  UBOOT_SIZE := 131072
  CONFIG_SIZE := 65536
  ART_SIZE := 65536
  NO_ART := 0
  IMAGE_SIZE := 15552k
  MASTER_IMAGE_SIZE := 16384k
  IMAGES := sysupgrade.bin \
            $(if $(CONFIG_BUILD_FACTORY_IMAGE),master_fw.bin)
  IMAGE/sysupgrade.bin = append-kernel | pad-to $$$$(BLOCKSIZE) | \
                         append-rootfs | pad-rootfs | append-metadata | \
                         check-size $$$$(IMAGE_SIZE) | finalize-tlt-webui
  IMAGE/master_fw.bin = append-tlt-uboot | pad-to $$$$(UBOOT_SIZE) | \
                        append-tlt-config | pad-to $$$$(CONFIG_SIZE) | \
                        append-tlt-art | pad-to $$$$(ART_SIZE) | \
                        append-kernel | pad-to $$$$(BLOCKSIZE) | \
                        append-rootfs | pad-rootfs | \
                        append-version | \
                        check-size $$$$(MASTER_IMAGE_SIZE) | \
                        finalize-tlt-master-stendui
  HW_MODS := ftdi_new blv1
endef

include $(SUBTARGET).mk

$(eval $(call BuildImage))
