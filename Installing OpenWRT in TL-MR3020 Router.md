# Installing OpenWRT in TL-MR3020 Router

## Connecting the router and installing OpenWRT

* Connect the ethernet cable and the power one

* In a web browser, go to http://192.168.0.254/ (user: admin, password: admin)

* Navigate to "System Tools" -> "Firmware Upgrade"

* Select the firmware file "openwrt-ar71xx-generic-tl-mr3020-v1-squashfs-factory.bin"

* Click upgrade

* Wait until the system reboots


## Configure the router and connect to internet

* In a web browser, go to http://192.168.1.1/ (user: root, without passwoord)

* Click in the "Go to password configuration..." link, in the red message

* Set password to 1234 (in both input field)

* Click "Save & apply"

* Navigate to "Network" -> "Wifi"

* Remove the existing cofiguration, clicking on button "Remove"

* Click on "Scan"

* Select a Wifi that you know, and click in "Join Network"

* Just put the password and click on "Submit" and then on "Save an Apply"



## Mount and boot from the system from USB

* Format a USB Stick with 2 partitons: an Ext3/Ext4 one, and a swap one

* From a terminal, log in via ssh ( "ssh root@192.168.1.1" , "1234" as password ) 

*Check if we have internet access 
    
```	
# ping www.google.com
PING www.google.com (216.58.210.164): 56 data bytes
64 bytes from 216.58.210.164: seq=0 ttl=55 time=10.162 ms
```

* Add USB support to OpenWrt

```
# opkg update
# opkg install kmod-usb-uhci
# insmod usbcore ## may return: file exists
# insmod uhci
# opkg install kmod-usb-ohci ## may return: up to date.
# insmod usb-ohci
# opkg install block-mount kmod-fs-ext4 kmod-usb-storage
```

* Plug the USB drive into the router.

* Check that the drive and partitions are being detected:

```
# ls /dev | grep sda
sda
sda1
sda2
```

## Setting up the filesystem

* Setup sda1 as a pivot overlay on the root file system

```
# mkdir /mnt/sda1
# mount /dev/sda1 /mnt/sda1
# mount | grep sda1
/dev/sda1 on /mnt/sda1 type ext4 (rw,relatime,user_xattr,barrier=1,data=ordered)
```

* Copy files from the router’s flash storage to the usb drive

```
# tar -C /overlay -cvf - . | tar -C /mnt/sda1 -xf -
```

* Edit /etc/config/fstab to automount /dev/sda1

```
# vi /etc/config/fstab
```

Use the following configuration.

```
config global automount
    option from_fstab 1
    option anon_mount 1

config global autoswap
    option from_fstab 1
    option anon_swap 0

config mount
    option target   /overlay
    option device   /dev/sda1
    option fstype   ext4
    option options  rw,sync
    option enabled  1
    option enabled_fsck 0

config swap
    option device   /dev/sda2
    option enabled  0
```

* Now reboot the router:

```
# reboot
```

* Once all of the lights on the router have come back on, SSH into the router again and check that the USB drive mounted properly.

```
# mount | grep sda1
/dev/sda1 on /overlay type ext4 (rw,sync,relatime,user_xattr,barrier=1,data=ordered)
```

* We will install some extra packages thet we will need

```
# opkg update
# opkg install vim bash curl tcpdump 
```

* Edit the /etc/passwd file to use bash instead of ash

```
# vim /etc/passwd

root:x:0:0:root:/root:/bin/bash

```

* Reconect SSH to have bash



### Setting up the swap partition


The router does not have very much on-board memory, so if we try to execute any long-running processes, it will likely run out of memory and reboot itself. 

* To check the available memory on the router, enter:
```
# free
```

You will notice that Swap has zeros across the board. We can use the swap partition we created earlier to ensure we have plenty of memory available.

*  Make sure the partition can function as swap:

```
# mkswap /dev/sda2
```

* Then turn activate the swap space

```
# swapon /dev/sda2
```

Now run free again to make sure the space was allocated

```
# free
             total         used         free       shared      buffers
Mem:         29212        19160        10052            0         1972
-/+ buffers:              17188        12024
Swap:       475644            0       475644  
```

* We will create a startup script

```
# vim /etc/init.d/swapon
```

with this content

```
#!/bin/bash /etc/rc.common

START=109
STOP=151

start() {
    echo "start swap"
    swapon /dev/sda2
}

stop(){
    echo "stop"
}
```

* Make the script executable

```
# chmod +x /etc/init.d/swapon
```

* Now we need to make a symlink from /etc/rc.d to our script to make the system run it on startup

```
# ln -s /etc/init.d/swapon /etc/rc.d/S109swapon
```

* Reboot

## Setting the timezone and the access to the internet

* Navigate to Network -> Interfaces and set the IPv4 gateway to 192.168.1.1. Also use custom DNS servers. Take i.e. the Google ones: 8.8.8.8 and 8.8.4.4.

* Navigate to System -> System. Set the hostname to anything different in each device (i.e. OpenWrt-x) and select your timezone.

* Apply the changes.