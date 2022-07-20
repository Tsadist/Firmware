#!/bin/bash

function result {
res=$(cat results.txt)
whiptail --title "Результаты тестирования" --msgbox "$res" 30 60
}
