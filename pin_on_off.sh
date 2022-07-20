#!/bin/bash

function on {
raspi-gpio set $1 op dh
}


function off {
raspi-gpio set $1 op dl
}


