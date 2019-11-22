#! /bin/bash

# ignore CTRL-C press in this script ---------
trap '' INT
# ignore CTRL-C press in this script ---------

sudo dmesg -D 2> /dev/null

echo ""
echo ""
echo ""
echo ""

echo "####################################"
echo ""
echo ' press "A" to enter your screename'
echo "        or wait 3 seconds"
echo ""

screen_name=''
name_set=0

echo -n 'press "A" ';
for _ in {1..3}; do
    read -rs -n1 -t1 name1 > /dev/null 2>&1
    ret=$?
    if [ $ret -eq 0 ]; then
        if [ "$name1""x" == "ax" ]; then
            echo ""
            read -p 'New Screenname : ' -t60 -r -e screen_name
            name_set=1
            break
        else
            echo -n '.'
        fi
    else
        echo -n '.'
    fi
done

echo ""

if [ $name_set -eq 1 ]; then
    if [ "$screen_name""x" != "x" ]; then
        echo ""
        echo ""
        echo "Screenname will be : ""$screen_name"
        echo "$screen_name" > /home/pi/ToxBlinkenwall/toxblinkenwall/toxname.txt 2> /dev/null
        echo ""
        echo ""
        sleep 5
    fi
fi

sudo dmesg -E 2> /dev/null
