#!/bin/bash

# Copyright 2017 Robert W Igo
#
# bob@igo.name
# http://bob.igo.name
# http://www.linkedin.com/profile/view?id=22294307
#
# This file is part of AirQuality.
# 
# AirQuality is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# AirQuality is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with AirQuality.  If not, see <http:#www.gnu.org/licenses/>.

OPENHAB_URL=http://openhab.igo:8080
OPENHAB_LARGE_PARTICLES_ITEM=Large_Particles
OPENHAB_SMALL_PARTICLES_ITEM=Small_Particles

Usage() {
    echo "USAGE:"
    echo `basename $0` "[-p PORT]"
    echo "-p: Serial port where your DC1100 is attached (omit to try auto-discovery)"
    echo "e.g."
    echo "$0 -p /dev/ttyUSB0"
    exit 4
}

while getopts "p:" FLAG ; do
    case "$FLAG" in
	p) port="$OPTARG";;
	*) Usage;;
    esac
done

# Try to auto-determine the port if it's not provided. This makes a big assumption that only one FTDI serial device
# converter is attached via USB and that it's the DC1100.
if [ "$port" == "" ]; then
    port="/dev/"`grep -a 'FTDI USB Serial Device converter now attached to' /var/log/kern.log | tail -1 | awk -F 'now attached to ' '{print $2}'`
fi

if [ "$port" == "/dev/" ]; then
    Usage
fi

stty -F $port 9600 cs8 -cstopb -parenb

while read -r line < $port; do
    echo $line
    small=`echo $line | awk -F',' '{print $1}'`
    large=`echo $line | awk -F',' '{print $2}'`
    curl --header "Content-Type: text/plain" --request PUT --data $small ${OPENHAB_URL}/rest/items/${OPENHAB_SMALL_PARTICLES_ITEM}/state
    curl --header "Content-Type: text/plain" --request PUT --data $large {$OPENHAB_URL}/rest/items/${OPENHAB_LARGE_PARTICLES_ITEM}/state
done
