#Purpose

* This program interfaces with a Dylos DC1100 air quality monitor and reports the large and small particle count to openHAB each minute.

#Features

1. Integration with [openHAB](http://openhab.org/) via its [RESTful API](https://github.com/openhab/openhab1-addons/wiki/Samples-REST). On the openHAB side, you can react accordingly to changes in air quality, such as send yourself a push notification warning of bad air quality.

#HOWTO

##What You Need

* A Linux computer (conventional or single-board) with a free USB port.

* A [Dylos DC1100 air quality monitor with 'PC interface'](http://www.dylosproducts.com/dcairqumowip.html).

* A [serial-to-USB converter cable](https://www.google.com/search?q=serial+to+usb+converter+cable&client=ubuntu&hs=Yls&channel=fs&source=lnms&tbm=isch&sa=X&ved=0ahUKEwi-vriUqZDTAhXl34MKHSivDDMQ_AUICSgC&biw=1654&bih=1253)

* Basic Linux skills (file copying and editing).

##Installation and Configuration

* Add these items to your openHAB installation's main items file, optionally adding them to an item group if you prefer:

```Number Small_Particles  "Small Air Particles [%d]" <climate>```
```Number Large_Particles  "Large Air Particles [%d]" <climate>```

* Install ```dc1100.sh``` to your computer and run ```chmod +x``` on it to make it executable. Alternatively, if you are familiar with ansible, you will find an ansible configuration for installing and auto-running the software on a Raspberry Pi.

* Edit ```dc1100.sh``` and change the values of ```OPENHAB_URL``` to match your openHAB configuration.

* Connect your computer to your DC1100 with your serial-to-USB converter cable.

* Run ```ls -tr /dev/tty* | tail -1```. You should see a filename like ```/dev/ttyUSB0```. This is the device file for the DC1100 on your computer.

* If you know that this is your only attached tty device, you can just run ```./dc1100.sh```, and it will auto-discover your device. Otherwise, you may pass a parameter to force the device file selection. For example, to use ```/dev/ttyUSB1```, run ```./dc1100.sh -p /dev/ttyUSB1```