define Device/TEMPLATE_teltonika_tcr100
	$(Device/teltonika_tcr1xx)
	$(Device/tlt-24kc-hw-common)
	DEVICE_MODEL := TCR100

	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.2.4

	DEVICE_WLAN_BSSID_LIMIT := wlan0 8, wlan1 8

	DEVICE_LAN_OPTION := eth0

	DEVICE_WAN_OPTION := eth1

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.1,

	DEVICE_NET_CONF :=     \
		vlans          16, \
		max_mtu        1500

	DEVICE_INTERFACE_CONF += guest proto static type bridge \
		guest 1 _wireless true _dhcp true

	DEVICE_FEATURES := mobile wifi dual_band_ssid wps ethernet nat_offloading small_flash reset_button

	HARDWARE/System_Characteristics/RAM := $(HW_RAM_SIZE_128M), $(HW_RAM_TYPE_DDR2)
	HARDWARE/WAN/Port := 1 $(HW_ETH_WAN_PORT)
	HARDWARE/WAN/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/WAN/Standard := $(HW_ETH_LAN_STANDARD)
	HARDWARE/LAN/Port := 1 $(HW_ETH_LAN_PORT)
	HARDWARE/LAN/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/LAN/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Wireless/Wireless_mode := $(HW_WIFI_5)
	HARDWARE/Physical_Interfaces/Ethernet := 2 $(HW_ETH_RJ45_PORTS), $(HW_ETH_SPEED_100)
	HARDWARE/Physical_Interfaces/Power := $(HW_INTERFACE_POWER_4PIN)
	HARDWARE/Physical_Interfaces/SIM := 1 $(HW_INTERFACE_SIM_HOLDER) (Embedded SIM variant available)
	HARDWARE/Physical_Interfaces/Antennas := 2 x SMA for LTE, 2 x Internal for 2.4 GHz Wi-Fi, 1 x Internal for 5 GHz Wi-Fi
	HARDWARE/Power/Power_consumption := 3.7 W average, 9.3 W max
	HARDWARE/Physical_Interfaces/Status_leds := 1 x Internet, 1 x WiFi, 3 x Mobile connection strength, 2 x Ethernet status
	HARDWARE/Physical_Specification/Weight := 376 g
	HARDWARE/Physical_Specification/Dimensions := 150 x 37 x 105 mm
	HARDWARE/Physical_Interfaces/WiFi := Wi-Fi enable/disable button
	HARDWARE/Physical_Interfaces/WPS := WPS activation button
	HARDWARE/Physical_Specification/Casing_material := Plastic housing with aluminum screws and heatsink
	HARDWARE/Operating_Environment/Ingress_Protection_Rating :=
endef
