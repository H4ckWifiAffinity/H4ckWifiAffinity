#!/bin/bash

interface=wlan0
dump_command='tcpdump -e -s 256 type mgt subtype probe-resp or subtype probe-req -I -i '$interface
server_protocol= 'http://'
server_url= 'localhost'
server_port= '8080'
server_full_url = $server_protocol$server_url':'$server_port

parse_response() {
	#echo '----------------------------------------------------------------'
	#echo 'Probe Response'
	#echo 'hora: '$1
	#echo 'frecuencia: '$6 $7
	#echo 'canal:' $8
	#echo 'intensidad: ' $9
	#echo ${13}
	#echo ${16}
	#echo ${19}
	#echo ${24}
	json_data='{package_type: response, time : '$1' ,frequency: '$6',channel_type : '$8',ssi: '$9', '${13}', '${16}', '${19}', ssid:'${24}'}'
	#echo $json_data
	send_data $json_data
}

parse_request(){
	#echo '----------------------------------------------------------------'
	#echo 'Probe Request'
	#echo 'hora: '$1
	#echo 'frecuencia: '$6 $7
	#echo 'canal:' $8
	#echo 'intensidad: ' $9
	#echo ${13}
	#echo ${15}
	#echo ${20}
	json_data='{package_type: request, time : '$1' ,frequency: '$6',channel_type : '$8',ssi: '$9', '${13}', '${15}', ssid:'${20}'}'
	#echo $json_data
	send_data $json_data
}

send_data (){
	curl --request POST $server_full_url'/login/' --data $1
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

