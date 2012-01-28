#! /usr/bin/env bash

function die_usage () {
    echo "usage: $0 {+|-}num"
    exit 1
}

if [ $# -lt 1 ] || [ $1 == '-h' ] || [ $1 == '--help' ]; then
    die_usage
fi

sign=${1:0:1}
num=${1:1}

path=/sys/class/backlight/acpi_video0
br=`cat $path/brightness`

if [ $sign == '-' ]; then
    let br-=num
    if [ $br -lt 0 ]; then
        br=0
    fi
elif [ $sign == '+' ]; then
    let br+=num
    max=`cat $path/max_brightness`
    if [ $br -gt $max ]; then
        br=$max
    fi
else
    die_usage
fi

echo $br > $path/brightness
