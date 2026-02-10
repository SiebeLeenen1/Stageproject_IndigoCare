/*
 * Common functions for MediaTek/Ralink Wireless SOC based boards support
 *
 * Copyright (C) 2021 Jokubas Maciulaitis <jokubas.maciulaitis@teltonika.lt>
 *
 * Based on:
 * u-boot/board/ar7240/common/common.c
 *
 * SPDX-License-Identifier: GPL-2.0
 */

#include <config.h>
#include <common.h>
#include <flash.h>
#include <asm/mipsregs.h>
#include <asm/addrspace.h>
#include <soc/mtk_soc_common.h>
#include <mtk_gpio.h>
#include "mnf_info.h"

#define ALIGN_SIZE "8"
#define ARRAY_MAX_LED_COUNT 8

/*
 * In case CONFIG_MTK_GPIO_MASK_LED_ACT_H is not defined, define it as empty
 * since it is used in led_animation function
 */
#ifndef CONFIG_MTK_GPIO_MASK_LED_ACT_H
#define CONFIG_MTK_GPIO_MASK_LED_ACT_H 0
#endif // CONFIG_MTK_GPIO_MASK_LED_ACT_H

DECLARE_GLOBAL_DATA_PTR;

static uint64_t global_led_animation_mask[ARRAY_MAX_LED_COUNT] = { 0 };
static char global_led_animation_mask_len = 0;
static u32 mac_is_not_valid = 0;

extern u64 global_active_high_mask;
extern u64 global_active_low_mask;

/*
 * Put MTK SOC name, version and eco id in buffer
 */
void mtk_soc_name_rev(char *buf)
{
	u32 val;
	u32 eco;
	u32 ver;
	u64 chip_id;

	if (buf == NULL)
		return;

	/* Get CHIP_ID ASCII values */
	chip_id = (u64)RALINK_REG(MTK_SYSCTL_CHIP_ID_0);
	chip_id += ((u64)RALINK_REG(MTK_SYSCTL_CHIP_ID_1) << 32);

	for (val = 0; val < sizeof(chip_id); val++) {
		*(buf + val) = chip_id & 0xFF;
		chip_id >>= 8;

		if (*(buf + val) == 0x20) {
			// space ASCII value, abort
			break;
		}
	}

	*(buf + val + 1) = '\0';

	/* Get CHIP_REV_ID value */
	val = RALINK_REG(MTK_SYSCTL_CHIP_REV_ID);

	eco = (val & MTK_SYSCTL_CHIP_REV_ID_ECO_MASK) >>
	      MTK_SYSCTL_CHIP_REV_ID_ECO_SHIFT;
	ver = (val & MTK_SYSCTL_CHIP_REV_ID_VER_MASK) >>
	      MTK_SYSCTL_CHIP_REV_ID_VER_SHIFT;

	sprintf(buf + strlen(buf), "ver. %d eco. %d", ver, eco);
}

/*
 * Returns last reset reason:
 * 1 -> reset by watchdog
 * 0 -> normal reset
 */
int last_reset_wdt()
{
	u32 reg;

	reg = RALINK_REG(MTK_SYSCTL_RSTSTAT);
	if (reg & MTK_SYSCTL_RSTSTAT_WDRST_MASK)
		return 1;

	return 0;
}

/*
 * Prints available information about the board
 */
void print_board_info(void)
{
	u32 ahb_clk, cpu_clk, ddr_clk, spi_clk, ref_clk;
	u32 bank;
	bd_t *bd = gd->bd;
	char buffer[24];

	/* Show warning if last reboot was caused by SOC watchdog */
	if (last_reset_wdt())
		printf_wrn("reset caused by watchdog!\n\n");

	/* Board name */
	printf("%" ALIGN_SIZE "s %s\n",
	       "BOARD:", MK_STR(CONFIG_BOARD_CUSTOM_STRING));

	/* SOC name, version and revision */
	mtk_soc_name_rev(buffer);
	printf("%" ALIGN_SIZE "s %s\n", "SOC:", buffer);

	/* MIPS CPU type */
	cpu_name(buffer);
	printf("%" ALIGN_SIZE "s %s\n", "CPU:", buffer);

	/* RAM size and type */
	printf("%" ALIGN_SIZE "s ", "RAM:");
	print_size(bd->bi_memsize, "");

	switch (mtk_dram_type()) {
	case RAM_MEMORY_TYPE_DDR1:
		puts(" DDR1 ");
		break;
	case RAM_MEMORY_TYPE_DDR2:
		puts(" DDR2 ");
		break;
	default:
		break;
	}

	/* DDR interface width */
	printf("%d-bit ", mtk_dram_ddr_width());

	/* tCL-tRCD-tRP-tRAS latency */
	printf("CL%d-%d-%d-%d\n", mtk_dram_cas_lat(), mtk_dram_trcd_lat(),
	       mtk_dram_trp_lat(), mtk_dram_tras_lat());

	/* SPI NOR FLASH sizes and types */
	printf("%" ALIGN_SIZE "s ", "FLASH:");

	for (bank = 0; bank < CFG_MAX_FLASH_BANKS; bank++) {
		if (flash_info[bank].size == 0)
			continue;

		if (bank > 0)
			printf("%" ALIGN_SIZE "s ", " ");

		print_size(flash_info[bank].size, "");

		if (flash_info[bank].manuf_name != NULL)
			printf(" %s", flash_info[bank].manuf_name);

		if (flash_info[bank].model_name != NULL)
			printf(" %s", flash_info[bank].model_name);

		puts("\n");
	}

	/* MAC address */
	printf("%" ALIGN_SIZE "s %02X:%02X:%02X:%02X:%02X:%02X",
	       "MAC:", bd->bi_enetaddr[0], bd->bi_enetaddr[1],
	       bd->bi_enetaddr[2], bd->bi_enetaddr[3], bd->bi_enetaddr[4],
	       bd->bi_enetaddr[5]);

	if (mac_is_not_valid)
		puts(" (fixed)\n");
	else
		puts("\n");

	/* System clocks */
	printf("%" ALIGN_SIZE "s CPU/RAM/AHB/SPI/REF\n", "CLOCKS:");

	mtk_sys_clocks(&cpu_clk, &ddr_clk, &ahb_clk, &spi_clk, &ref_clk);
	cpu_clk = cpu_clk / 1000000;
	ddr_clk = ddr_clk / 1000000;
	ahb_clk = ahb_clk / 1000000;
	spi_clk = spi_clk / 1000000;
	ref_clk = ref_clk / 1000000;

	printf("%" ALIGN_SIZE "s %3d/%3d/%3d/%3d/%3d MHz\n", " ", cpu_clk,
	       ddr_clk, ahb_clk, spi_clk, ref_clk);

	puts("\n");
}

/*
 * Reads MAC address if available or uses fixed one
 */
void macaddr_init(u8 *mac_addr)
{
	u8 buffer[6];
	u8 fixed_mac[6] = {0x00, 0x03, 0x7F, 0x09, 0x0B, 0xAD};

#if defined(OFFSET_MAC_ADDRESS)
	memcpy(buffer, (void *)(CFG_FLASH_BASE
		+ OFFSET_MAC_DATA_BLOCK + OFFSET_MAC_ADDRESS), 6);

	/*
	 * Check first LSBit (I/G bit) and second LSBit (U/L bit) in MSByte of vendor part
	 * both of them should be 0:
	 * I/G bit == 0 -> Individual MAC address (unicast address)
	 * U/L bit == 0 -> Burned-In-Address (BIA) MAC address
	 */
	if (CHECK_BIT((buffer[0] & 0xFF), 0) != 0 ||
	    CHECK_BIT((buffer[0] & 0xFF), 1) != 0) {
		memcpy(buffer, fixed_mac, 6);
		mac_is_not_valid = 1;
	}
#else
	memcpy(buffer, fixed_mac, 6);
	mac_is_not_valid = 1;
#endif

	memcpy(mac_addr, buffer, 6);
}

/*
 * Returns "reset button" status:
 * 1 -> button is pressed
 * 0 -> button is not pressed
 */
int reset_button_status(void)
{
#if defined(CONFIG_GPIO_RESET_BTN)
	u32 gpio;

	gpio = RALINK_REG(mtk_gpio_data_reg(CONFIG_GPIO_RESET_BTN));

	if (gpio & mtk_gpio_mask(CONFIG_GPIO_RESET_BTN)) {
	#if defined(CONFIG_GPIO_RESET_BTN_ACTIVE_LOW)
		return 0;
	#else
		return 1;
	#endif
	} else {
	#if defined(CONFIG_GPIO_RESET_BTN_ACTIVE_LOW)
		return 1;
	#else
		return 0;
	#endif
	}
#else
	return 0;
#endif
}

/*
 * Returns "digital input" status:
 * 1 -> input is set
 * 0 -> input is not set
 */
int digital_in_status(void)
{
#if defined(CONFIG_GPIO_MASK_DIGITAL_IN_OLD)
	u32 gpio, num;
	const uint64_t old_gpio_mask[] = { CONFIG_GPIO_MASK_DIGITAL_IN_OLD };
	const uint64_t new_gpio_mask[] = { CONFIG_GPIO_MASK_DIGITAL_IN_NEW };
#if defined(CONFIG_DEVICE_LIST)
	const char *device_list[] = { CONFIG_DEVICE_LIST };
#else
	const char *device_list = NULL;
#endif
	int hwver_list[]     = { CONFIG_HW_VERSIONS };
	const char mnf_name[12];
	const char hwver[4];
	int mnf_hwver;

	mnf_get_field("name", mnf_name);
	mnf_get_field("hwver", hwver);

	if (hwver[0] != '0' || hwver[1] != '0') {
		mnf_hwver = (hwver[0] - '0') * 10 + (hwver[1] - '0');
	} else if (hwver[2] != '0' || hwver[3] != '0') {
		mnf_hwver = (hwver[2] - '0') * 10 + (hwver[3] - '0');
	} else {
		mnf_hwver = 0;
	}

	int len = sizeof(old_gpio_mask) / sizeof(old_gpio_mask[0]);
	for (u32 i = 0; i < len; i++) {
		if (device_list) {
			if (strncmp(device_list[i], mnf_name, strlen(device_list[i]))) {
				continue;
			}
		}

		num = hwver_list[i] > mnf_hwver ? mtk_gpio_num(old_gpio_mask[i]) :
						  mtk_gpio_num(new_gpio_mask[i]);
		break;
	}
	gpio = RALINK_REG(mtk_gpio_data_reg(num));
	return !(gpio & mtk_gpio_mask(num));
#elif defined(CONFIG_GPIO_MASK_DIGITAL_IN)
	u32 gpio, num;

	num  = mtk_gpio_num(CONFIG_GPIO_MASK_DIGITAL_IN);
	gpio = RALINK_REG(mtk_gpio_data_reg(num));

	return !(gpio & mtk_gpio_mask(num));
#else
	return 0;
#endif
}

static void set_global_led_animation_cfg(uint64_t from[], uint64_t to[])
{
	if (global_led_animation_mask_len > ARRAY_MAX_LED_COUNT) {
		global_led_animation_mask_len = ARRAY_MAX_LED_COUNT;
		printf("Error: max led count exceeded\n");
	}
	for (int i = 0; i < global_led_animation_mask_len; i++) {
		to[i] = from[i];
	}
}

#if defined(CONFIG_MTK_LED_ANIMATION_MASK)
void init_led_animation_array(void)
{
	uint64_t led_animation_mask[] = { CONFIG_MTK_LED_ANIMATION_MASK };

	global_led_animation_mask_len = sizeof(led_animation_mask) / sizeof(led_animation_mask[0]);

#if defined (CONFIG_FOR_TELTONIKA_TRB2M)
	uint64_t trb247_mask[] = { CONFIG_MTK_LED_ANIMATION_MASK_TRB247 };
	const char mnf_name[12];
	mnf_get_field("name", mnf_name);

	if (!strncmp(mnf_name, "TRB247", 6)) {
		global_active_high_mask = CONFIG_MTK_GPIO_MASK_LED_ACT_H_TRB247;
		global_active_low_mask = CONFIG_MTK_GPIO_MASK_LED_ACT_L_TRB247;
		global_led_animation_mask_len = sizeof(trb247_mask) / sizeof(trb247_mask[0]);
		set_global_led_animation_cfg(trb247_mask, global_led_animation_mask);

		return;
	}
#endif
	set_global_led_animation_cfg(led_animation_mask, global_led_animation_mask);

	return;
}
#endif // CONFIG_MTK_LED_ANIMATION_MASK

/*
 * Toggle GPIOs in normal or reverse order
 */
void led_animation(int reverse)
{
#if defined(CONFIG_MTK_LED_ANIMATION_MASK)
	static int cycle = 0;
	u32 num, reg, mask;

	if (!reverse) {
		if (cycle == global_led_animation_mask_len) {
			cycle = -1;

			for (u32 i = 0; i < global_led_animation_mask_len; i++) {
				num = mtk_gpio_num(global_led_animation_mask[i]);
				reg = mtk_gpio_data_reg(num);
				mask = mtk_gpio_mask(num);
				if (global_led_animation_mask[i] & global_active_high_mask) {
					RALINK_REG(reg) |= mask;
				} else {
					RALINK_REG(reg) &= ~mask;
				}
			}
			goto cycle_inc;
		}

		for (int i = 0; i <= cycle; i++) {
			num = mtk_gpio_num(global_led_animation_mask[i]);
			reg = mtk_gpio_data_reg(num);
			mask = mtk_gpio_mask(num);
			if (global_led_animation_mask[i] & global_active_high_mask) {
				RALINK_REG(reg) &= ~mask;
			} else {
				RALINK_REG(reg) |= mask;
			}
		}

cycle_inc:
		cycle++;
		return;
	} else {
		if (cycle == 0) {
			cycle = global_led_animation_mask_len;

			for (u32 i = 0; i < global_led_animation_mask_len; i++) {
				num = mtk_gpio_num(global_led_animation_mask[i]);
				reg = mtk_gpio_data_reg(num);
				mask = mtk_gpio_mask(num);
				if (global_led_animation_mask[i] & global_active_high_mask) {
					RALINK_REG(reg) |= mask;
				} else {
					RALINK_REG(reg) &= ~mask;
				}
			}
 			return;
		}

		for (int i = global_led_animation_mask_len - 1; i >= cycle - 1; i--) {
			num = mtk_gpio_num(global_led_animation_mask[i]);
			reg = mtk_gpio_data_reg(num);
			mask = mtk_gpio_mask(num);
			if (global_led_animation_mask[i] & global_active_high_mask) {
				RALINK_REG(reg) &= ~mask;
			} else {
				RALINK_REG(reg) |= mask;
			}
		}
		cycle--;
	}
#endif
}

/*
 * Returns main CPU clock in Hz
 */
u32 main_cpu_clk(void)
{
	u32 cpu_clk;

	mtk_sys_clocks(&cpu_clk, NULL, NULL, NULL, NULL);

	return cpu_clk;
}

/*
 * Calls full chip reset
 */
void full_reset(void)
{
	mtk_full_chip_reset();
}
