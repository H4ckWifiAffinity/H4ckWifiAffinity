#!/bin/bash

interface=$1
router=$2
dump_command='tcpdump -e -s 256 type mgt subtype probe-req -i '$interface
# TODO: Validate input parameters
working_seconds=10
idle_seconds=20
server_protocol='http://'
server_url='localhost'
server_port='3000'
server_full_url=$server_protocol$server_url':'$server_port


function parse_request {
	local signal=`echo $@ | grep -o '[^ ,]\+ signal' | grep -o '\-[0-9]\+'`
	if ! [ -z "$signal" ];
	then
		local time="$(date +%s)"
		# local router= `/sbin/ifconfig | grep \'$interface\' | tr -s ' ' | cut -d ' ' -f5`
		# local router=$(ifconfig wlan0 | grep -o -E "([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}")
		# local bssid=`echo $@ | grep -o 'BSSID:[^ ,]\+' | cut -c 7-`
		# local da=`echo $@ | grep -o 'DA:[^ ,]\+' | cut -c 4-`
		local sa=`echo $@ | grep -o 'SA:[^ ,]\+' | cut -c 4-`
		local freq=`echo $@ | grep -o '[^ ,]\+ MHz' | grep -o '[0-9]\+'`
		local json_data='{"type":"request","router":"'$router'","time":"'$time'","signal":'$signal',"src":"'$sa'","freq":'$freq'}'
		send_data $json_data
	fi
}

function send_data {

	# echo $json_data

	curl -i \
	-H "Content-Type:application/json" \
	-X POST --data $json_data \
	$server_full_url'/api/adddump/'
	json_array=0-9
}


function start_dumping () {
	$dump_command | while read dump_output; do
		parse_request $dump_output
	done	
}

start_dumping


