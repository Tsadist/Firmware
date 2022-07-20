#!/bin/bash
source Testing.sh

rm conf.txt

OPTION=$(whiptail --title "Перечень устройств" --menu "Выберете устройство для тестирования" 20 85 7 \
"1" 'Мезонинная плата "Мезонин Duo" (2-х симочная) для "Умный двор" (Smart gate)' \
"2" 'Мезонинная плата "Мезонин Uno" (1 симочная) для "Умный двор" (Smart gate)'  3>&1 1>&2 2>&3)

function get {
echo $1 >> conf.txt
test
}

case $OPTION in

1)
	get 'Мезонинная плата "Мезонин Duo" (2-х симочная) для "Умный двор" (Smart gate)';;
2)
	get 'Мезонинная плата "Мезонин Uno" (1 симочная) для "Умный двор" (Smart gate)';;
esac

cat conf.txt
