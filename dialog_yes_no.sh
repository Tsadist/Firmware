#!/bin/bash


function yesno {
if (whiptail --title "$1" --yesno "$2" 10 60) 
then
 echo "$3" >> results.txt
else
 echo "$4" >> results.txt
fi
}
