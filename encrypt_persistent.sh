#! /bin/bash

# wait for other boot messages to dissapear
sleep 5

# find correct device name
# and change to partition number 3 on the boot device
device_=$(lsblk -nP -o name,mountpoint 2>/dev/null | grep '"/lib/live/mount/medium"' 2>/dev/null | awk '{ print $1 }' 2>/dev/null | awk -F'=' '{ print $2 }' 2>/dev/null | tr -d '"' 2>/dev/null | sed 's/1$/3/' 2>/dev/null )
echo "####################################"
echo ""
echo "found USB boot device: /dev/""$device_"
echo ""

if [ "$device_""x" == "x" ]; then
    # error!! block forever
    while [ 1 == 1 ]; do
        echo '!!DEVICE ERROR D-001 !!'
        sleep 10
    done
fi

# get full device path
device_="/dev/""$device_"

sleep 2

# check if its the first boot ---------
mount -t ext4 "$device_" /mnt > /dev/null 2> /dev/null
err=$?
# check if its the first boot ---------

if [ $err -eq 0 ]; then

    # check if its really really the correct filesystem/partition
    # since we are going to fully overwrite it
    if [ ! -f "/mnt/__tbw_persist_part__" ]; then
        # error!! block forever
        while [ 1 == 1 ]; do
            echo '!!DEVICE ERROR D-002 !!'
            sleep 10
        done
    fi

    echo "####################################"
    echo "####################################"
    echo "####################################"
    echo "####################################"
    echo "####################################"
    echo "####################################"
    echo ""
    echo "------- SETUP data encryption -------"
    echo "------- pick a strong password ------"
    echo ""

    # unmount and encrypt
    umount -f "$device_" >/dev/null 2> /dev/null
    cryptsetup -y -q luksFormat "$device_"
    err2=$?
    if [ $err2 -eq 0 ]; then
        echo ""
        echo "------ UNLOCK data encryption ------"
        echo "---- ENTER your password again -----"
        echo ""

        cryptsetup luksOpen "$device_" tbwdb
        err3=$?
        mkfs.ext4 -e panic -U "0e113e75-b4df-418d-98f5-da6a763c1228" /dev/mapper/tbwdb >/dev/null 2> /dev/null
        if [ $err3 -eq 0 ]; then
            mkdir -p /home/pi/ToxBlinkenwall/toxblinkenwall/db >/dev/null 2> /dev/null
            mount -o "rw,noatime,nodiratime,sync,data=ordered" /dev/mapper/tbwdb /home/pi/ToxBlinkenwall/toxblinkenwall/db >/dev/null 2> /dev/null
            err4=$?
            if [ $err4 -eq 0 ]; then
                chown -R pi:pi /home/pi/ToxBlinkenwall/toxblinkenwall/db/ >/dev/null 2> /dev/null
                chmod u+rwx /home/pi/ToxBlinkenwall/toxblinkenwall/db/ >/dev/null 2> /dev/null

                echo ""
                echo ""
                echo "         ++ LUKS init OK ++"
                echo ""
                echo ""
                sleep 3
            else
                # error!! block forever
                while [ 1 == 1 ]; do
                    echo '!!LUKS ERROR 003 !!'
                    sleep 10
                done
            fi
        else
            # error!! block forever
            while [ 1 == 1 ]; do
                echo '!!LUKS ERROR 002 !!'
                sleep 10
            done
        fi
    else
        # error!! block forever
        while [ 1 == 1 ]; do
            echo '!!LUKS ERROR 001 !!'
            sleep 10
        done
    fi
else
    echo "####################################"
    echo "####################################"
    echo "####################################"
    echo "####################################"
    echo "####################################"
    echo "####################################"
    echo ""
    echo "------ UNLOCK data encryption ------"
    echo "------- ENTER your password --------"
    echo ""

    # try to unlock and mount
    cryptsetup luksOpen "$device_" tbwdb
    err3=$?
    if [ $err3 -eq 0 ]; then
        mkdir -p /home/pi/ToxBlinkenwall/toxblinkenwall/db >/dev/null 2> /dev/null
        mount -o "rw,noatime,nodiratime,sync,data=ordered" /dev/mapper/tbwdb /home/pi/ToxBlinkenwall/toxblinkenwall/db >/dev/null 2> /dev/null
        err4=$?
        if [ $err4 -eq 0 ]; then
            chown -R pi:pi /home/pi/ToxBlinkenwall/toxblinkenwall/db/ >/dev/null 2> /dev/null
            chmod u+rwx /home/pi/ToxBlinkenwall/toxblinkenwall/db/ >/dev/null 2> /dev/null
            echo ""
            echo ""
            echo "         ## LUKS open OK ##"
            echo ""
            echo ""
            sleep 3
        else
            # error!! block forever
            while [ 1 == 1 ]; do
                echo '!!LUKS ERROR 005 !!'
                sleep 10
            done
        fi
    else
        # error!! block forever
        while [ 1 == 1 ]; do
            echo '!!LUKS ERROR 004 !!'
            sleep 10
        done
    fi
fi
