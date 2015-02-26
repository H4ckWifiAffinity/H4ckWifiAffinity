#!/bin/bash

interface=wlan0
dump_command='tcpdump -e -s 256 type mgt subtype probe-resp or subtype probe-req -I -i '$interface
working_seconds=10
idle_seconds=20
server_protocol='http://'
server_url='localhost'
server_port='3000'
server_full_url=$server_protocol$server_url':'$server_port

json_array="["

function parse_response {
	local signal=`echo $@ | grep -o '[^ ,]\+ signal' | grep -o '\-[0-9]\+'`
	if ! [ -z "$signal" ];
	then
		local time=$1
		local noise=`echo $@ | grep -o '[^ ,]\+ noise' | grep -o '\-[0-9]\+'`
		if [ -z "$noise" ];
		then
			local noise=-100
		fi
		local bssid=`echo $@ | grep -o 'BSSID:[^ ,]\+' | cut -c 7-`
		local da=`echo $@ | grep -o 'DA:[^ ,]\+' | cut -c 4-`
		local sa=`echo $@ | grep -o 'SA:[^ ,]\+' | cut -c 4-`
		local freq=`echo $@ | grep -o '[^ ,]\+ MHz' | grep -o '[0-9]\+'`
		local channel=`echo $@ | grep -o 'CH: [^ ,]\+' | grep -o '[0-9]\+'`
		local json_data='{"type":"response","time":"'$time'","signal":'$signal',"noise":'$noise',"bssid":"'$bssid'","dst":"'$da'","src":"'$sa'","freq":'$freq',"ch":'$channel'}'
		json_array=$json_array$json_data","
	fi
}

function parse_request {
	local signal=`echo $@ | grep -o '[^ ,]\+ signal' | grep -o '\-[0-9]\+'`
	if ! [ -z "$signal" ];
	then
		local time=$1
		local noise=`echo $@ | grep -o '[^ ,]\+ noise' | grep -o '\-[0-9]\+'`
		if [ -z "$noise" ];
		then
			local noise=-100
		fi
		local bssid=`echo $@ | grep -o 'BSSID:[^ ,]\+' | cut -c 7-`
		local da=`echo $@ | grep -o 'DA:[^ ,]\+' | cut -c 4-`
		local sa=`echo $@ | grep -o 'SA:[^ ,]\+' | cut -c 4-`
		local freq=`echo $@ | grep -o '[^ ,]\+ MHz' | grep -o '[0-9]\+'`
		local json_data='{"type":"request","time":"'$time'","signal":'$signal',"noise":'$noise',"bssid":"'$bssid'","dst":"'$da'","src":"'$sa'","freq":'$freq'}'
		json_array=$json_array$json_data","
	fi
}

function send_data {
	json_array=${json_array::-1}']'
	#echo $json_array
	curl -i \
	-H "Content-Type:application/json" \
	-X POST --data $json_array \
	$server_full_url'/api/adddump/'
	json_array=0
}


function start_dumping () {
	local starttime="$(date +%s)"
	$dump_command | while read dump_output; do
	   if [[ $dump_output == *"Response"* ]]
	   	then
	   	parse_response $dump_output
	   elif [[ $dump_output == *"Request"* ]]; then
	   	parse_request $dump_output
	   fi
	   local now="$(date +%s)"
	   local elapsed=$((now  - starttime))
	   #echo $elapsed
	   if [ $elapsed -gt $working_seconds ];
	   	then
	   	send_data
	   	return
	   fi
	done	
	echo "Waiting "$idle_seconds" seconds"
	sleep $idle_seconds
   	start_dumping	
}

start_dumping


