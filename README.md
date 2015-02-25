# Documentación (preliminar)

## Uso de tcpdump

```bash
tcpdump -e -s 256 type mgt subtype probe-resp or subtype probe-req -I
```
El parámetro -I es el más importante. Pone a la tarjeta de red en "modo promiscuo", de modo que captura TODOS los paquetes que circulan por la red, y no sólo los dirigidos a nuestra interfaz.

Si se desean filtrar los paquetes que van o proceden de una dirección MAC en concreto, se puede filtrar con ```grep```.

```bash
tcpdump -e -s 256 type mgt subtype probe-resp or subtype probe-req -I | grep xx:xx:xx:xx:xx:xx
```

### Ejemplo de request

```
18:11:35.785252 659741466us tsft 1.0 Mb/s 2462 MHz 11g -58dB signal -95dB noise antenna 0 BSSID:Broadcast DA:Broadcast SA:10:68:3f:4e:52:0a (oui Unknown) Probe Request () [1.0 2.0 5.5 11.0 Mbit]
```

18:11:35.785252 659741466us tsft 1.0 Mb/s 2462 MHz 11g

**-58dB signal**

-95dB noise

antenna 0 BSSID:Broadcast DA:Broadcast SA:10:68:3f:4e:52:0a (oui Unknown)

Probe Request ()

[1.0 2.0 5.5 11.0 Mbit]

### Ejemplo de response

```
18:11:35.812619 659745307us tsft 1.0 Mb/s 2462 MHz 11g -55dB signal -95dB noise antenna 0 BSSID:e8:94:f6:51:31:20 (oui Unknown) DA:10:68:3f:4e:52:0a (oui Unknown) SA:e8:94:f6:51:31:20 (oui Unknown) Probe Response (Kunlabori) [1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH: 11, PRIVACY
```

18:11:35.812619 659745307us tsft 1.0 Mb/s 2462 MHz 11g

**-55dB signal**

-95dB noise

antenna 0 BSSID:e8:94:f6:51:31:20 (oui Unknown)

DA:**10:68:3f:4e:52:0a** (oui Unknown)

SA:e8:94:f6:51:31:20 (oui Unknown)

Probe Response (Kunlabori)

[1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] CH: 11, PRIVACY

## Script

Se usan expresiones regulares y algunos comandos como ```grep``` para obtener la info de los paquetes que se obtienen de la red y obtener a partir de ellos un array de objetos JSON válido. Aquí habría que estudiar si se envían uno por uno los objetos JSON al servidor, o si se crean batches de objetos (temporales o por número de paquetes).

También hay que optimizar las expresiones regulares, pero en una primera iteracción lo importante es que sean JSON válido.

# Recursos

## A nivel teórico

- How to calculate distance from Wifi router using Signal Strength?
[link](http://stackoverflow.com/questions/11217674/how-to-calculate-distance-from-wifi-router-using-signal-strength)

- WiFi Positioning System [link](http://en.wikipedia.org/wiki/Wi-Fi_positioning_system)

- Where’ve you been? Your smartphone’s Wi-Fi is telling everyone [link](http://arstechnica.com/information-technology/2014/11/where-have-you-been-your-smartphones-wi-fi-is-telling-everyone/)

- 802.11 WLAN Packet Types [link](http://www.wildpackets.com/resources/compendium/wireless_lan/wlan_packet_types)

- tcpdump promiscuous mode on OSX [link](http://superuser.com/questions/541728/tcpdump-promiscuous-mode-on-osx-10-8)

- 802.11 Association process explained [link](https://kb.meraki.com/knowledge_base/80211-association-process-explained)

- RadioTap Headers [link](http://wifinigel.blogspot.com.es/2013/11/what-are-radiotap-headers.html)

## Heatmaps

- WebGL Heatmap [link](https://github.com/pyalot/webgl-heatmap)

- heatcanvas [link](https://github.com/sunng87/heatcanvas)

## Firmares OpenSource

- DD-WRT [link](http://www.dd-wrt.com/site/index)

- OpenWrt [link](http://wiki.openwrt.org/toh/start)

- List of wireless router firmware projects [link](http://www.wikiwand.com/en/List_of_wireless_router_firmware_projects)

## La competencia

- Análisis Local [link](http://www.analisislocal.com/)

## Spatial databases

- wiki / list [link](http://www.wikiwand.com/en/Spatial_database)

- GeoTools [link](http://www.geotools.org/)

- MongoDB: Geospatial Indexes and Queries [link](http://docs.mongodb.org/manual/applications/geospatial-indexes/)

## TODO List

- Diferencias entre distintos tipos de dispositivos, si es que las hay
- Probar tanto con Wireshark como con tcpdump (parsear los resultados de tcpdump a JSON)
- Mapas de calor - si Analytics no tiene, hay que usar un HTML canvas, APIs de frontend para mapas de calor (WebGL, D3.js, CartoDB)
- Buscar bases de datos específicas para geolocalización (GIS)
- Firmwares libres para los routers (dd wrt)
- Interfaz REST para obtener los JSON y almacenarlos en la base de datos del servidor

