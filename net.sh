#! /bin/bash

export PATH=/sbin:$PATH

# clear all rules
tc qdisc del dev eth0 root
# tc -p qdisc ls dev eth0

# ----------------
# 1) delay and packet loss
tc qdisc add dev eth0 root netem loss 2% 5% delay 200ms 20ms distribution normal
# ----------------

# ----------------
# 2) rate limit (this seems not to work)
# tc qdisc add dev eth0 root tbf rate 256kbit burst 1600 limit 3000
# ----------------

# ----------------
# 3) delay and rate limit (this seems not to work)
# tc qdisc add dev eth0 root handle 1: tbf rate 256kbit buffer 1600 limit 3000
# tc qdisc add dev eth0 parent 1:1 handle 10: netem delay 100ms
# ----------------

# tc -p qdisc ls dev eth0


