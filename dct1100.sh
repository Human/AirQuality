#!/bin/bash

# Copyright 2017 Robert W Igo
#
# bob@igo.name
# http://bob.igo.name
# http://www.linkedin.com/profile/view?id=22294307
#
# This file is part of DeskAttendant.
# 
# DeskAttendant is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# DeskAttendant is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with DeskAttendant.  If not, see <http:#www.gnu.org/licenses/>.

# Try to auto-determine the port. This makes a big assumption that only one FTDI serial device
# converter is attached via USB and that it's the DCT1100.
if [ "$port" == "" ]; then
    port="/dev/"`grep -a 'FTDI USB Serial Device converter now attached to' /var/log/kern.log | tail -1 | awk -F 'now attached to ' '{print $2}'`
fi

# These values work on the Dylos DCT1100
stty -F $port 9600 cs8 -cstopb -parenb

#cat $port
# now outputs particle count every minute
while read -r line < $port; do
    echo $line
    small=`echo $line | awk -F',' '{print $1}'`
    large=`echo $line | awk -F',' '{print $2}'`
    curl --header "Content-Type: text/plain" --request PUT --data $small http://openhab.igo:8080/rest/items/Small_Particles/state
    curl --header "Content-Type: text/plain" --request PUT --data $large http://openhab.igo:8080/rest/items/Large_Particles/state
done
