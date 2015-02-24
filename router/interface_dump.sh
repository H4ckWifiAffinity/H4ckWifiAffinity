#!/bin/bash

interface=wlan0
dump_command='tcpdump -e -s 256 type mgt subtype probe-resp or subtype probe-req -I -i '$interface

parse_response() {
	echo '----------------------------------------------------------------'
	echo 'Probe Response'
	echo 'hora: '$1
	echo 'frecuencia: '$6 $7
	echo 'canal:' $8
	echo 'intensidad: ' $9
	echo ${13}
	echo ${16}
	echo ${19}
	echo ${24}

}

parse_request(){
	echo '----------------------------------------------------------------'
	echo 'Probe Request'
	echo 'hora: '$1
	echo 'frecuencia: '$6 $7
	echo 'canal:' $8
	echo 'intensidad: ' $9
	echo ${13}
	echo ${15}
	echo ${20}
}

$dump_command | while read dump_output; do
	echo '----------------------------------------------------------------'
   	echo $dump_output
   if [[ $dump_output == *"Response"* ]]
   	then
   	parse_response $dump_output
   elif [[ $dump_output == *"Request"* ]]; then
   	parse_request $dump_output
   fi
	
done

