#!/bin/bash

interface=en0
dump_command='tcpdump -e -s 256 type mgt subtype probe-resp or subtype probe-req -I -i '$interface
server_protocol='http://'
server_url='localhost'
server_port='8080'
server_full_url=$server_protocol$server_url':'$server_port

function parse_response {
	local time=$1
	local signal=`echo $@ | grep -o '[^ ,]\+ signal'`
	local noise=`echo $@ | grep -o '[^ ,]\+ noise'`
	local bssid=`echo $@ | grep -o 'BSSID:[^ ,]\+'`
	local da=`echo $@ | grep -o 'DA:[^ ,]\+'`
	local sa=`echo $@ | grep -o 'SA:[^ ,]\+'`
	local freq=`echo $@ | grep -o '[^ ,]\+ MHz' | grep -o '[1-9]\+'`
	local channel=`echo $@ | grep -o 'CH: [^ ,]\+' | grep -o '[1-9]\+'`
	local json_data='{package_type: RESPONSE, time: '$time', signal: '$signal', noise: '$noise', BSSID: '$bssid', DA: '$da', SA: '$sa', freq: '$freq', channel: '$channel'}'
	send_data $json_data
}

function parse_request {
	local time=$1
	local signal=`echo $@ | grep -o '[^ ,]\+ signal'`
	local noise=`echo $@ | grep -o '[^ ,]\+ noise'`
	local bssid=`echo $@ | grep -o 'BSSID:[^ ,]\+'`
	local da=`echo $@ | grep -o 'DA:[^ ,]\+'`
	local sa=`echo $@ | grep -o 'SA:[^ ,]\+'`
	local freq=`echo $@ | grep -o '[^ ,]\+ MHz'`
	local json_data='{package_type: REQUEST, time: '$time', signal: '$signal', noise: '$noise', BSSID: '$bssid', DA: '$da', SA: '$sa', freq: '$freq', channel: '$channel'}'
	send_data $json_data
}

function send_data {
	#curl --request POST $server_full_url'/login/' --data $1
	echo $@
}

$dump_command | while read dump_output; do
	#echo '----------------------------------------------------------------'
   	#echo $dump_output
   if [[ $dump_output == *"Response"* ]]
   	then
   	parse_response $dump_output
   elif [[ $dump_output == *"Request"* ]]; then
   	parse_request $dump_output
   fi
	
done

