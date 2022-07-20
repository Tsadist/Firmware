#!/bin/bash
. ./dialog_yes_no.sh
. ./pin_on_off.sh

function contact1 {
if [[ $1 == *"1"* ]]
then
on 16
yesno "Проверка левого сухого контакта" "Светодиод загорелся?" "Светодиод на левом сухом контакте: работает" "Светодиод на левом сухом контакте: не работает"
yesno "Проверка левого сухого контакта" "Проверьте левый контакт пищалкой мультиметра. \nПри замыкании есть писк?" "Левый сухой контакт: работает" "Левый сухой контакт: не работает"
off 16
fi
}

function contact2 {
if [[ $1 == *"2"* ]]
then
on 23
yesno "Проверка правого сухого контакта" "Светодиод загорелся?" "Светодиод на правом сухом контакте: работает" "Правый сухой контакт: не работает"
yesno "Проверка правого сухого контакта" "Проверьте правый контакт пищалкой мультиметра. \nПри замыкании есть писк?" "Правый сухой контакт: работает" "Правй сухой контакт: не работает"
off 23
fi
}

function dry_contacts {
dry_key=$(whiptail --title "Проверка ключей сухих контактов" --inputbox "Введите какие из ключей сухих контактов есть на плате" 10 60 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ];
then
        contact1 "$dry_key"
        contact2 "$dry_key"
else
        echo "Отказ от ввода"
fi
}