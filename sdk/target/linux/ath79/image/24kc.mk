#
# MIPS 24Kc Devices
#

include devices/common_24kc.mk
include devices/rut3xx_family.mk
include devices/trb2xx_family.mk
include devices/tcr1xx_family.mk

define Device/qca9531
	SOC := qca9531
endef

define Device/teltonika_trb2xx
	$(Device/qca9531)
	DEVICE_MODEL := TRB2XX
	DEVICE_BOOT_NAME := tlt-trb24x
	DEVICE_DTS := qca9531_teltonika_trb2xx
	DEVICE_FEATURES += gateway gps serial serial-reset-quirk modbus io \
			single_port dualsim bacnet ntrip mobile 64mb_ram dot1x-server no-wired-wan
	NO_ART := 1
	GPL_PREFIX := GPL
	# Default common packages for TRB2XX series
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# Essential must-have:
	DEVICE_PACKAGES := kmod-spi-gpio

	# USB related:
	DEVICE_PACKAGES += kmod-usb2 kmod-cypress-serial kmod-usb-serial-pl2303 \
			   kmod-usb-serial-ftdi
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	INCLUDED_DEVICES := \
		TEMPLATE_teltonika_trb245 \
		TEMPLATE_teltonika_trb255

	DEVICE_MODEM_VENDORS := Quectel
	DEVICE_MODEM_LIST := EC20 EC25 BG96

endef

define Device/teltonika_rut30x
	$(Device/qca9531)
	DEVICE_MODEL := RUT30X
	DEVICE_BOOT_NAME := tlt-rut300
	DEVICE_DTS := qca9531_teltonika_rut30x
	DEVICE_FEATURES += usb-port serial io port-mirror basic-router 64mb_ram \
			ledman-lite ntrip
	NO_ART := 1
	GPL_PREFIX := GPL
	# Default common packages for RUT30X series
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# USB related:
	DEVICE_PACKAGES += kmod-usb2
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	INCLUDED_DEVICES := TEMPLATE_teltonika_rut300
endef
TARGET_DEVICES += teltonika_rut30x

define Device/teltonika_rut36x
	$(Device/qca9531)
	DEVICE_MODEL := RUT36X
	DEVICE_BOOT_NAME := tlt-rut360
	DEVICE_DTS := qca9531_teltonika_rut36x
	DEVICE_FEATURES += io wifi mobile 128mb_ram
	GPL_PREFIX := GPL
	# Default common packages for RUT36X series
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# Essential must-have:
	DEVICE_PACKAGES := kmod-spi-gpio

	# USB related:
	DEVICE_PACKAGES += kmod-usb2

	# Wireless related:
	DEVICE_PACKAGES += kmod-ath9k_54
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	DEVICE_MODEM_VENDORS := Quectel
	DEVICE_MODEM_LIST := EG06

	INCLUDED_DEVICES := TEMPLATE_teltonika_rut360
endef

define Device/teltonika_tcr1xx
	$(Device/qca9531)
	DEVICE_MODEL := TCR1XX
	DEVICE_BOOT_NAME := tlt-tcr1xx
	DEVICE_DTS := qca9531_teltonika_tcr1xx
	DEVICE_FEATURES += wifi guest-wifi rfkill wps mobile 128mb_ram
	GPL_PREFIX := GPL
	# Default common packages for TCR1XX series
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# Essential must-have:
	DEVICE_PACKAGES := kmod-spi-gpio

	# USB related:
	DEVICE_PACKAGES += kmod-usb2

	# Wireless related:
	DEVICE_PACKAGES += kmod-ath9k_54 kmod-ath10k_54 ath10k-firmware-qca9887
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	DEVICE_MODEM_VENDORS := Quectel
	DEVICE_MODEM_LIST := EG06

	INCLUDED_DEVICES := TEMPLATE_teltonika_tcr100
endef
