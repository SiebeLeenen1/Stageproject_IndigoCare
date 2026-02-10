define Device/teltonika_rut3_common
	$(Device/tlt-24kc-hw-common)
	HARDWARE/WAN/Port := 1 $(HW_ETH_WAN_PORT)
	HARDWARE/WAN/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/WAN/Standard := $(HW_ETH_LAN_STANDARD)
	HARDWARE/LAN/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/LAN/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Physical_Interfaces/Power := $(HW_INTERFACE_POWER_4PIN)
	HARDWARE/Physical_Interfaces/IO := $(HW_INTERFACE_IO_4PIN_IN_OUT)
	HARDWARE/Physical_Specification/Dimensions := 100 x 30 x 85 mm
	HARDWARE/Physical_Specification/Casing_material := $(HW_PHYSICAL_HOUSING_AL)
	HARDWARE/Physical_Specification/Mounting_options := $(HW_PHYSICAL_MOUNTING_KIT)
endef

define Device/TEMPLATE_teltonika_rut300
	$(Device/teltonika_rut30x)
	$(Device/teltonika_rut3_common)
	DEVICE_MODEL := RUT300

	DEVICE_WAN_OPTION := eth1

	DEVICE_USB_JACK_PATH := /usb1/1-1/

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.1

	DEVICE_NET_CONF :=       \
		vlans          16,   \
		max_mtu        1500, \
		readonly_vlans 1

	DEVICE_FEATURES := usb ethernet ios nat_offloading small_flash reset_button

	DEVICE_SWITCH_CONF := switch0 \
			0@eth0 1:lan:1 2:lan:4 3:lan:3 4:lan:2

	HARDWARE/LAN/Port := 4 $(HW_ETH_LAN_PORTS)
	HARDWARE/Physical_Interfaces/Ethernet := 5 $(HW_ETH_RJ45_PORTS), $(HW_ETH_SPEED_100)
	HARDWARE/USB/Data_rate := $(HW_USB_2_DATA_RATE)
	HARDWARE/Physical_Interfaces/USB := 1 $(HW_INTERFACE_USB)
	HARDWARE/USB/Applications := $(HW_USB_APPLICATIONS)
	HARDWARE/USB/External_devices := $(HW_USB_EXTERNAL_DEV)
	HARDWARE/USB/Storage_formats := $(HW_USB_STORAGE_FORMATS)
	HARDWARE/Power/PoE_Standards := $(HW_POWER_POE_PASSIVE_30V)
	HARDWARE/Input_Output/Input := 2 x Configurable digital Inputs. Digital input 0 - 5 V detected as logic low, 8 - 30 V detected as logic high.
	HARDWARE/Input_Output/Output := 2 x Configurable digital Outputs. Open collector output, max output 30 V, 300 mA
	HARDWARE/Physical_Interfaces/Status_leds := 5 x ETH status, 1 x Power
	HARDWARE/Power/Power_consumption := Idle 1.3 W, Max 3 W
	HARDWARE/Physical_Specification/Weight := 229 g
endef
TARGET_DEVICES += TEMPLATE_teltonika_rut300

define Device/TEMPLATE_teltonika_rut360
	$(Device/teltonika_rut36x)
	$(Device/teltonika_rut3_common)
	DEVICE_MODEL := RUT360

	DEVICE_WAN_OPTION := eth1

	DEVICE_LAN_OPTION := eth0

	DEVICE_WLAN_BSSID_LIMIT := wlan0 8

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.1

	DEVICE_NET_CONF := \
		vlans          16, \
		max_mtu        1500

	DEVICE_FEATURES := mobile wifi dual_band_ssid ethernet ios nat_offloading small_flash reset_button

	HARDWARE/System_Characteristics/RAM := $(HW_RAM_SIZE_128M), $(HW_RAM_TYPE_DDR2)
	HARDWARE/LAN/Port := 1 $(HW_ETH_LAN_PORT)
	HARDWARE/Wireless/Wireless_mode := 802.11 b/g/n, 2x2 MIMO, Access Point (AP), Station (STA)
	HARDWARE/Physical_Interfaces/SIM := 1 $(HW_INTERFACE_SIM_HOLDER)
	HARDWARE/Physical_Interfaces/Ethernet := 2 $(HW_ETH_RJ45_PORTS), $(HW_ETH_SPEED_100)
	HARDWARE/Input_Output/Input := 1 $(HW_INPUT_DI_30V)
	HARDWARE/Input_Output/Output := 1 $(HW_OUTPUT_DO_30V)
	HARDWARE/Physical_Interfaces/Status_leds := 2 x Mobile connection type, 3 x Mobile connection strength, 2 x Eth status, 1 x Power
	HARDWARE/Power/Power_consumption := 10.5 W max
	HARDWARE/Physical_Interfaces/Antennas := 2 x SMA for LTE, 2 x RP-SMA for Wi-Fi
	HARDWARE/Physical_Specification/Weight := 247 g
endef
