#!/bin/sh

. /lib/functions/uci-defaults.sh

ucidef_target_defaults() {
	local model="$1"
	local branch_path="/sys/mnf_info/branch"
	local branch
	[ -f "$branch_path" ] && branch="$(cut -c -2 $branch_path)"

	case "$model" in
	RUT36*)
		ucidef_add_static_modem_info "$model" "1-1" "primary"
	;;
	TRB2*)
		ucidef_add_static_modem_info "$model" "1-1.4" "primary" "gps_out"
	;;
	TCR1*)
		ucidef_add_static_modem_info "$model" "1-1" "primary"
	;;
	esac
}
