# Router Script

## Description

The idea of this script is to listen to every Probe Request and Probe Response in the router and send it to a server that should be listening and specting the JSON package that this script sends.

## Instalation

### Hardware

This scrip was tested in a TP-Link TL-MR3020

###  Firmware

To be able to run custom scripts, and OpenWrt firmware was installed, replacing the original one.
The bin file can se found in the resources folder

###  Customization

Due to we need to install custom software, we had to configure the router to:

- Enable SSH conection from the web interface
- Connect it to a local wireless network, to be able to download and install new software
- Enable the USB port to detect memory sticks (we will need to mount the file system there)
- Move the file system and boot from the USB (due to the memory device it is very limited)
- Install necesary packages (tcpdump, bash, curl)
- Put the device in monitor mode
- Run the scipt

To achive these items, we follow the instructions in these pages:

- Passive WiFi Tracking [link](http://edwardkeeble.com/2014/02/passive-wifi-tracking/)
- PirateBox DIY [link](http://daviddarts.com/piratebox-diy-openwrt/)

and due to some error dettecting the memory stick, this one was util too:

- OpenWRT on TP-Link MR3020 as infopoint with local webserver [link](http://wolfgang.reutz.at/2012/04/12/openwrt-on-tp-link-mr3020-as-infopoint-with-local-webserver/)