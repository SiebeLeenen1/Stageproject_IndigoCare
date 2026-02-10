#!/bin/sh

usage() {
	echo "Usage: $0 <[-BbfCa]> [-h]
Options:
  -B | --bar                   Fill signal bar with delay
  -b | --boot                  Show booting animation
  -f | --flash                 Show flashing animation
  -C | --clean                 Turn off all leds and exit
  -a | --auto                  Return to autonomous operation
  -D | --debug                 Enable debugging output
  -d | --daemon                Run as daemon
  -h | --help                  Print this message"
}

gpio_dir() {
	[ -n "$2" ] && echo "$2" > /sys/class/gpio/$1/direction
}

led_manual() {
	echo none > /sys/class/leds/$1/trigger
	[ -n "$2" ] && echo "$2" > /sys/class/leds/$1/brightness
}


led_timer() {
	echo timer > /sys/class/leds/$1/trigger
	[ -n "$2" ] && echo "$2" > /sys/class/leds/$1/delay_on
	[ -n "$2" ] && echo "$3" > /sys/class/leds/$1/delay_off
}

led_switch() {
	echo switch0 > /sys/class/leds/$1/trigger
	[ -n "$2" ] && echo $2 > /sys/class/leds/$1/port_mask
	[ -n "$3" ] && echo $3 > /sys/class/leds/$1/speed_mask
	[ -n "$4" ] && echo "$4" > /sys/class/leds/$1/mode
}

led_netdev() {
	echo netdev > /sys/class/leds/$1/trigger
	[ -n "$2" ] && echo $2 > /sys/class/leds/$1/device_name
	[ -n "$3" ] && {
		for m in $3; do
			[ -e "/sys/class/leds/$1/$m" ] && echo 1 > /sys/class/leds/$1/$m
		done
	}
	[ -n "$4" ] && echo $4 > /sys/class/leds/$1/interval
}

export_in_gpios () {
	for rng in $@; do
		for i in $(seq $(echo "$rng" | cut -f 1 -d '-') $(echo "$rng" | cut -f 2 -d '-'));do
			echo $i > /sys/class/gpio/export 2> /dev/null
		done
	done
}


#############
#  Generic  #
#############

generic_bar() {
	"$1"_reload
	led_timer power_led 1000 1000
}

generic_boot() {
	"$1"_reload
	led_timer power_led 500 500
}

generic_flash() {
	"$1"_reload
	led_timer power_led 125 125
}

generic_auto() {
	"$1"_reload
}

generic_daemon() {
	"$1"_reload
}

generic_clean() {
	"$1"_clean
}

############
#    ETH   #
############

eth_prepare() {
	pgrep -f "ledman \-" | awk -v me=$$ 'me != $1 {print $1}' | xargs kill 2> /dev/null

	for led in $(ls /sys/class/leds | grep -v power); do
		led_manual "$led" 0
	done

	led_manual "$1" "$2"
}

eth_bar_bg() {
	for led in $(ls /sys/class/leds | grep -v power); do
		sleep 2
		led_manual "$led" 1
	done
}

eth_bar() {
	eth_prepare "$1" 1
	eth_bar_bg &
}

eth_boot() {
	eth_prepare "$1" 1

	for led in $(ls /sys/class/leds | grep -v power); do
		led_timer "$led" 500 500
	done
}

eth_flash_bg() {
	led=""

	while true; do
		for idx in "$@"; do
			[ -n "$led" ] && led_manual "$led" 0
			[ "$idx" -eq 0 ] && led="wan_led" || led="eth${idx}_led"
			led_manual "$led" 1
			sleep 1
		done
	done
}

eth_clean() {
	eth_prepare "$1" 0
}

############
#  RUT14X  #
############

rut14x_reload() {
	eth_prepare power_led 1

	led_switch eth1_led "0x02"
	led_switch wan_led "0x01"
}

rut14x_bar() {
	eth_bar power_led
}

rut14x_boot() {
	eth_boot power_led
}

rut14x_flash() {
	eth_prepare power_led 1
	eth_flash_bg 1 0 &
}

rut14x_clean() {
	eth_clean power_led
}

rut14x_auto() {
	rut14x_reload
}

rut14x_daemon() {
	rut14x_reload
}

############
#  RUT300  #
############

rut300_reload() {
	eth_prepare power 1

	led_switch eth1_led "0x02"
	led_switch eth2_led "0x10"
	led_switch eth3_led "0x08"
	led_switch eth4_led "0x04"
	led_netdev wan_led eth1 "link tx rx" 50
}

rut300_bar() {
	eth_bar power
}

rut300_boot() {
	eth_boot power
}

rut300_flash() {
	eth_prepare power 1
	eth_flash_bg 1 2 3 4 0 4 3 2 &
}

rut300_clean() {
	eth_clean power
}

rut300_auto() {
	rut300_reload
}

rut300_daemon() {
	rut300_reload
}

############
#  RUT301  #
############

rut301_reload() {
	eth_prepare power_led 1

	led_switch eth1_led "0x01"
	led_switch eth2_led "0x02"
	led_switch eth3_led "0x04"
	led_switch eth4_led "0x08"
	led_switch wan_led "0x10"
}

rut301_bar() {
	eth_bar power_led
}

rut301_boot() {
	eth_boot power_led
}

rut301_flash() {
	eth_prepare power_led 1
	eth_flash_bg 1 2 3 4 0 4 3 2 &
}

rut301_clean() {
	eth_clean power_led
}

rut301_auto() {
	rut301_reload
}

rut301_daemon() {
	rut301_reload
}

############
#  TAP100  #
############

tap100_reload() {
	led_switch eth0_led "0x10"
	led_manual gp_led 0
	led_manual power_led 1
}

tap100_clean() {
	led_manual eth0_led 0
	led_manual gp_led 0
	led_manual power_led 0
}

############
#  TAP400  #
############

tap400_reload() {
	echo on > "/sys/kernel/debug/mdio-bus:0f/led"
	led_manual power_led 1
}

tap400_clean() {
	echo off > "/sys/kernel/debug/mdio-bus:0f/led"
	led_manual power_led 0
}

############
#  TSW202  #
############

tsw202_set_gpio_dir() {
	#killall other ledman instances
	ps | grep -E "ledman \-" | awk -v me=$$ 'me != $1 {print $1}' | xargs kill 2> /dev/null

	for gp in $(ls /sys/class/leds | grep port); do
		led_manual "$gp" 0
	done

	for gp in $(ls /sys/class/gpio | grep gpio4); do
		gpio_dir "$gp" "$1"
	done
}

tsw202_reload() {
	tsw202_set_gpio_dir "in"
}

tsw202_bar_bg() {
	for idx in $(seq 1 2 8); do
		led_manual "yellow:eth_port_${idx}" 1
		led_manual "green:eth_port_${idx}" 1
		led_manual "yellow:eth_port_$((idx+1))" 1
		led_manual "green:eth_port_$((idx+1))" 1
		sleep 2
	done

	led_manual "yellow:sfp_port_1" 1
	led_manual "yellow:sfp_port_2" 1
}

tsw202_bar() {
	tsw202_set_gpio_dir "out"

	tsw202_bar_bg &
}

tsw202_boot() {
	tsw202_set_gpio_dir "out"
	for gp in $(ls /sys/class/leds | grep port); do
		led_timer "$gp"
	done
}

tsw202_flash_bg() {
	while true; do
		# forwards
		for idx in $(seq 1 2 8); do
			led_manual "yellow:eth_port_${idx}" 1
			led_manual "yellow:eth_port_$((idx+1))" 1
			usleep 125000
			led_manual "yellow:eth_port_${idx}" 0
			led_manual "yellow:eth_port_$((idx+1))" 0
			led_manual "green:eth_port_${idx}" 1
			led_manual "green:eth_port_$((idx+1))" 1
			usleep 125000
			led_manual "green:eth_port_${idx}" 0
			led_manual "green:eth_port_$((idx+1))" 0
		done

		led_manual "yellow:sfp_port_2" 1
		usleep 125000
		led_manual "yellow:sfp_port_2" 0
		led_manual "yellow:sfp_port_1" 1
		usleep 125000
		led_manual "yellow:sfp_port_1" 0
		led_manual "yellow:sfp_port_2" 1
		usleep 125000
		led_manual "yellow:sfp_port_2" 0

		# backwards
		for idx in $(seq 7 -2 3); do
			led_manual "green:eth_port_${idx}" 1
			led_manual "green:eth_port_$((idx+1))" 1
			usleep 125000
			led_manual "yellow:eth_port_${idx}" 1
			led_manual "yellow:eth_port_$((idx+1))" 1
			led_manual "green:eth_port_${idx}" 0
			led_manual "green:eth_port_$((idx+1))" 0
			usleep 125000
			led_manual "yellow:eth_port_${idx}" 0
			led_manual "yellow:eth_port_$((idx+1))" 0
		done

		led_manual "green:eth_port_1" 1
		led_manual "green:eth_port_2" 1
		usleep 125000
		led_manual "green:eth_port_1" 0
		led_manual "green:eth_port_2" 0
	done
}

tsw202_flash() {
	tsw202_set_gpio_dir "out"

	tsw202_flash_bg &
}

tsw202_clean() {
	tsw202_set_gpio_dir "out"
	for gp in $(ls /sys/class/leds | grep port); do
		led_manual "$gp" 0
	done
}

tsw202_auto() {
	tsw202_reload
}

tsw202_daemon() {
	export_in_gpios 440-447 456-456 458-458 468-475
	tsw202_reload
}

##########
#  MAIN  #
##########

while getopts "BbfFCacdDh-:" opt; do
	case $opt in
		-)
			case ${OPTARG} in
				help)
					usage
					exit 0
					;;

				bar)
					ACTION="bar"
					;;
				boot)
					ACTION="boot"
					;;
				flash)
					ACTION="flash"
					;;
				clean)
					ACTION="clean"
					;;
				auto)
					ACTION="auto"
					;;
				daemon)
					[ -z "$ACTION" ] && ACTION="daemon"
					;;

				debug)
					echo "Unsupported action: '--${OPTARG}'"
					;;
				*)
					echo "Option does not exist: '--${OPTARG}'"
					usage
					exit 1
					;;

				esac
				;;

		h)
			usage
			exit 0
			;;

		B)
			ACTION="bar"
			;;
		b)
			ACTION="boot"
			;;
		f)
			ACTION="flash"
			;;
		C)
			ACTION="clean"
			;;
		a)
			ACTION="auto"
			;;
		d)
			[ -z "$ACTION" ] && ACTION="daemon"
			;;

		c|D)
			echo "Unsupported action: '-${opt}'"
			;;
		*)
			echo "Option does not exist: '-${opt}'"
			usage
			exit 1
			;;

	esac
done
shift $((OPTIND-1))

if [ "$(type -P mnf_info)" ]; then
	dev_name="$(mnf_info -n)"
else # Running in RAMDISK i.e. (no mnf_info binnary)
	dev_name="$(dd if=/dev/mtd1 bs=1 skip=$((0x10)) count=12)"
fi

[ -z "$ACTION" ] && {
	usage
	exit 1
}

[ "$(uci get system.ledman.enabled 2>/dev/null)" = "0" ]  && ACTION="clean"

case "$dev_name" in
	RUT14*|DAP14*)
		eval "rut14x_${ACTION}"
		;;
	RUT300*)
		eval "rut300_${ACTION}"
		;;
	RUT301*)
		eval "rut301_${ACTION}"
		;;
	TAP100*)
		eval "generic_${ACTION}" "tap100"
		;;
	TAP400*)
		eval "generic_${ACTION}" "tap400"
		;;
	TSW202*|TSW212*)
		eval "tsw202_${ACTION}"
		;;
	*)
		echo "Unsupported device"
		exit 1
		;;
esac
