#! /bin/bash

#*********************************
#
# ToxBlinkenwall - vm script
# (C)Zoff in 2020
#
# https://github.com/zoff99/ToxBlinkenwall
#
# run only inside a VM with a test TBW
#
#*********************************

sudo mkdir -p /home/pi/vmshare
sudo chmod a+rwx /home/pi/vmshare
# sudo mount -t ext4 /dev/vda /home/pi/vmshare
sudo chown pi:pi /home/pi/vmshare/
sudo chmod a+rwx /home/pi/vmshare/

sudo cp /net.sh /home/pi/vmshare/net.sh
sudo chown pi:pi /home/pi/vmshare/net.sh
sudo chmod a+rwx /home/pi/vmshare/net.sh

export PATH=/sbin:$PATH

while [ 1 == 1 ]; do
    sleep 2
    cp /home/pi/ToxBlinkenwall/toxblinkenwall/toxid.txt /home/pi/vmshare/
    # !! DANGER !!
    sudo bash /home/pi/vmshare/net.sh
    # !! DANGER !!
done