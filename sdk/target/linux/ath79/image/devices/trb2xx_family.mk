define Device/teltonika_trb2_common
	$(Device/tlt-24kc-hw-common)
	HARDWARE/Ethernet/Port :=1 $(HW_ETH_RJ45_PORT)
	HARDWARE/Ethernet/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/Ethernet/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Power/Connector := $(HW_POWER_CONNECTOR_16PIN)
	HARDWARE/Power/Input_voltage_range := $(HW_POWER_VOLTAGE_16PIN)
	HARDWARE/Input_Output/Input := 3 $(HW_INPUT_DI_30V). 1 x Analog input (0 - 30 V)
	HARDWARE/Input_Output/Output := 3 $(HW_OUTPUT_DO_30V)
	HARDWARE/Physical_Interfaces/Ethernet := 1 $(HW_ETH_RJ45_PORT), $(HW_ETH_SPEED_100)
	HARDWARE/Physical_Interfaces/Power := $(HW_INTERFACE_POWER_16PIN)
	HARDWARE/Physical_Interfaces/IO := $(HW_INTERFACE_IO_16PIN)
	HARDWARE/Physical_Interfaces/Antennas := 1 x SMA connector for LTE, 1 x SMA connector for GNSS
	HARDWARE/Physical_Interfaces/Status_leds := 3 x connection status LEDs, 3 x connection strength LEDs, 1 x power LED, 1 x Eth port status LED
	HARDWARE/Physical_Interfaces/RS232 := $(HW_INTERFACE_RS232_4PIN)
	HARDWARE/Physical_Interfaces/RS485 := $(HW_INTERFACE_RS485_4PIN)
	HARDWARE/Physical_Interfaces/SIM := 2 $(HW_INTERFACE_SIM_TRAY)
	HARDWARE/Serial/RS232 := Terminal block connector:TX, RX, RTS, CTS
	HARDWARE/Serial/RS485 := Terminal block connector:D+, D-, R+, R- (2 or 4 wire interface)
	HARDWARE/Serial/Serial_functions := Console, Serial over IP, Modem, MODBUS gateway, NTRIP Client
	HARDWARE/Power/Power_consumption := Idle < 1.2 W, Max < 5 W
	HARDWARE/Physical_Specification/Casing_material := $(HW_PHYSICAL_HOUSING_AL)
	HARDWARE/Physical_Specification/Mounting_options := $(HW_PHYSICAL_MOUNTING_KIT)
	HARDWARE/Physical_Specification/Weight := 165 g
	HARDWARE/Physical_Specification/Dimensions := 83 x 25 x 74.2 mm
endef

define Device/template_trb2
	$(Device/teltonika_trb2xx)

	DEVICE_LAN_OPTION := eth0

	DEVICE_NET_CONF :=       \
		vlans          16,   \
		max_mtu        1500

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.1

	DEVICE_FEATURES := gateway dual_sim mobile gps ethernet ios rs232 rs485 \
		nat_offloading xfrm-offload single_port small_flash reset_button

	DEVICE_DOT1X_SERVER_CAPABILITIES := false false single_port

	DEVICE_SERIAL_CAPABILITIES := \
		"rs232"                                                           \
			"300 600 1200 2400 4800 9600 19200 38400 57600 115200"        \
			"7 8"                                                         \
			"rts/cts xon/xoff none"                                       \
			"1 2"                                                         \
			"even odd mark space none"                                    \
			"none"                                                        \
			"/usb1/1-1/1-1.3/",                                           \
		"rs485"                                                           \
			"300 600 1200 2400 4800 9600 19200 38400 57600 115200 230400  \
			460800 921600 1000000 3000000"                                \
			"7 8"                                                         \
			"none"                                                        \
			"1 2"                                                         \
			"even odd mark space none"                                    \
			"half full"                                                   \
			"/usb1/1-1/1-1.2/"
endef

define Device/TEMPLATE_teltonika_trb245
	$(Device/teltonika_trb2_common)
	$(Device/template_trb2)
	DEVICE_MODEL := TRB245

endef

define Device/TEMPLATE_teltonika_trb255
	$(Device/teltonika_trb2_common)
	$(Device/template_trb2)
	DEVICE_MODEL := TRB255

endef
