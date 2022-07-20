#!/bin/bash

function GSM {
stty -F /dev/ttyS0 115200 -echo -inlcr
rm resultsGSM.txt

serport () {
cat /dev/ttyS0 > res.log &
touch res.log
echo $1 > /dev/ttyS0
sleep 1
ans=$(cat res.log)
echo "..."
echo "$ans"
if [[ $ans == *"OK"* ]]
then
con=`echo "Выполнена успешно"`
echo $con >> resultsGSM.txt
else
con=`echo "Возникли проблемы при выполнении"`
echo $con >> resultsGSM.txt
fi
killall cat
}


serport "ATI"
whiptail --title "Проверка GSM модуля" --msgbox "Команда ATI: $con" 10 60

serport "AT+IPR=115200"
whiptail --title "Проверка GSM модуля" --msgbox "Команда AT+IPR=115200: $con" 10 60

serport "AT&W"
whiptail --title "Проверка GSM модуля" --msgbox "Команда AT&W: $con" 10 60

serport "AT+CREG?"
if [[ $ans == *"0,1"* ]]
then
con1=`echo "Выполнена успешно"`
echo $con1 >> resultsGSM.txt
else
con1=`echo "Возникли проблемы при выполнении"`
echo $con1 >> resultsGSM.txt
fi
whiptail --title "Проверка GSM модуля" --msgbox "Команда AT+CREG?: $con1" 10 60

serport "AT+CMGF=1"
whiptail --title "Проверка GSM модуля" --msgbox "Команда AT+CMGF=1: $con" 10 60

serport "AT&W"
whiptail --title "Проверка GSM модуля" --msgbox "Команда AT&W: $con" 10 60


serport "ATD+79202113428;"
if (whiptail --title "Проверка GSM модуля" --yesno "Подождите несколько секунд. \nВам идёт звонок?" 10 60)
then
echo "Звонки на телефон идут" >> results.txt
else
echo "Проблема со звонками" >> results.txt
fi

whiptail --title "Проверка GSM модуля" --msgbox "Перезвоните на номер с которого поступил звонок" 10 60

{
    for ((i = 0 ; i <= 100 ; i+=15)); do
        sleep 1
        echo $i
    done
} | whiptail --gauge "Пожалуйста подождите немного" 6 60 0

serport "ATH"
if (whiptail --title "Проверка GSM модуля" --yesno "Звонок сбросился?" 10 60)
then
	con1=`echo "Выполнена успешно"`
	echo $con1 >> resultsGSM.txt
else
	con1=`echo "Возникли проблемы при выполнении"`
	echo $con1 >> resultsGSM.txt
fi

cat /dev/ttyS0 > res.log &
killall cat
cat /dev/ttyS0 >> res.log &
touch res.log
cat res.log
echo "AT+CPOWD=1" > /dev/ttyS0
{
    for ((i = 0 ; i <= 100 ; i+=2)); do
        sleep 1
        echo $i
    done
} | whiptail --gauge "Идет выполнение команды, подождите пожалуйста" 6 60 0

cat res.log
ans=$(cat res.log)
if [[ $ans == *"SMS"*"Ready" ]];
then
	con2=`echo "Выполнена успешно"`
	echo $con2 >> resultsGSM.txt
else
	con2=`echo "Возникли проблемы при выполнении"`
	echo $con2 >> resultsGSM.txt
fi
whiptail --title "Проверка GSM модуля" --msgbox "Команда AT+CPOWD=1: $con2" 10 60

cat resultsGSM.txt
rm res.log
killall cat


resultsGSM=`cat resultsGSM.txt`
if [[ $resultGSM == *"Возникли"* ]]
then
	echo "С GSM модулем возникли проблемы" >> results.txt
else
	echo "GSM модуль выполняет все требуемые функции" >> results.txt
fi
}
