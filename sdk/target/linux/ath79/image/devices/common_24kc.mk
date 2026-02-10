include $(INCLUDE_DIR)/hardware.mk

define Device/tlt-24kc-hw-common
	HARDWARE/System_Characteristics/CPU := QCA9531, MIPS 24kc, 650 MHz
	HARDWARE/System_Characteristics/RAM := $(HW_RAM_SIZE_64M), $(HW_RAM_TYPE_DDR2)
	HARDWARE/System_Characteristics/Flash_Storage := $(HW_FLASH_SIZE_16M) $(HW_FLASH_TYPE_SPI)
	HARDWARE/Power/Connector := $(HW_POWER_CONNECTOR_4PIN)
	HARDWARE/Power/Input_voltage_range := $(HW_POWER_VOLTAGE_4PIN_30V)
	HARDWARE/Physical_Interfaces/Reset := $(HW_INTERFACE_RESET)
	HARDWARE/Operating_Environment/Operating_Temperature := $(HW_OPERATING_TEMP)
	HARDWARE/Operating_Environment/Operating_Humidity := $(HW_OPERATING_HUMIDITY)
	HARDWARE/Operating_Environment/Ingress_Protection_Rating := $(HW_OPERATING_PROTECTION_IP30)
endef
