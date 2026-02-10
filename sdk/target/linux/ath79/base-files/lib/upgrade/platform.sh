#
# Copyright (C) 2021 Teltonika
#

. /usr/share/libubox/jshn.sh

PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

check_trb2_hw_mods() {
	local board="$1"

	[ "$board" != "TRB2" ] && return 0

	local ser_pid="$(cat /sys/bus/usb/devices/usb1/1-1/1-1.3/idProduct)"

	# ignore this validation if no FTDI is detected
	[ "$ser_pid" != "6001" ] && return 0

	local metadata="/tmp/sysupgrade.meta"
	local mod_ftdi_set=0

	[ -e "$metadata" ] || ( fwtool -q -i "$metadata" "$1" ) && {
		json_load_file "$metadata"

		if ( json_select hw_mods 1> /dev/null ); then
			json_select hw_mods
			json_get_values hw_mods

			echo "Mods found: $hw_mods"

			for mod in $hw_mods; do
				case "$mod" in
				"ftdi_new")
					mod_ftdi_set=1
					;;
				esac
			done
		fi
	}

	[ "$mod_ftdi_set" -eq 0 ] && {
		echo "FTDI serial chip detected but fw does not support it"
		return 1
	}

	return 0
}

platform_check_hw_support() {
	local board="$(mnf_info -n | cut -c -4)"

	check_trb2_hw_mods "$board" || return 1

	return 0
}

# this hook runs after fwtool validation
platform_check_image() {
	return 0
}
