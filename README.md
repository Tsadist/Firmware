Перечень устройств и их модули:
1. Мезонинная плата "Страж солнце"

        - менеджер управления питания на основе МК ATtiny13
        - ЧРВ с будильником "mcp7940x"
        - преобразователь интерфейса rs232uart
        - ключ управления вентилятором
       
2. Центральный модуль управления паркоматом

        - менеджер управления питания на основе мк ittyny13
        - ЧРВ с будильником "mcp7940x"
        - два преобразователя интерфейса
        - 3 входа типа "сухой контакт"
        - 2 выхода управления светодиодом
        - модем с супервизером на основе sim7600
        
3. Спутник А (файлы требуемые для выполнения wan.sh: libqmi-utils udhcpc)

        - ЧРВ "ds1307"
        - модем с супервизором на основе sim7600
        - многофункциональный светодиод
 
4. Мезонинная плата "Мезонин Duo" (2-х симочная) для "Умный двор" (Smart gate)

        - GSM модуль sim800
        - переферийный процессор от mega328p
        - 2 выхода "сухой контакт"
        - 3 ключа управления питанием камеры
        - ключ управления коммутатором
        - ключ управления вентилятором
        
4.1 Мезонинная плата "Мезонин Uno" (1 симочная) для "Умный двор" (Smart gate)

        - модем с супервизором на основе sim7600
        - 2 выхода "сухой контакт"
        - 3 ключа управления питанием камеры
        - ключ управления коммутатором
        - ключ управления вентилятором
        


1. Мезонинная плата "Страж солнце"

1.1. Питание

        ping 192.168.1.21

        ssh pi@192.168.1.21

1.2. Запуск вентилятора 

        raspi-gpio set 18 op dh //включить вентилятор
        raspi-gpio set 18 op dl //выключить вентилятор 
 
 1.3. ЧРВ  
 
        sudo hwclock -w
        //через 2-3 секунды
        sudo hwclock -r
 
 Если не работает:
 
        sudo nano /boot/config.txt  
        //dtverlay=i2c-rtc, mcp7940x, wekup-source
        //dtparam=i2c_arm=on
    
Выполнить:

        sudo raspi-config

Interface options - I2C - ON

        sudo reboot
        ping 192.168.1.21
        ssh pi@192.168.1.21
        sudo i2cdetect -y 1
        sudo hwclock -r
    
1.4. Прошивка

        sudo nano /boot/config.txt
        //dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0
        
        sudo nano /usr/local/etc/avrdude.conf
        // найти id = "linuxpi"; заменить reset 25 на 5; baudrate 400000 на 12000
        
        ./flash13 t13.hex       
        ./flash smartgate.hex   //Умный двор
        sudo halt
        
1.5. Комплексная проверка     

        ping 192.168.1.21
        
        ssh pi@192.168.1.21
        
        minicom -D /dev/ttyS0  //проверка преобразователя
    
Проверяем эхо. Выход: ctrl+a +x
        
        sudo hwclock -w  //синх-ия часов
        
        cat /proc/driver/rtc  // должны появится строки rtc_time и rtc_date
        
        sudo sh -c "echo 0 > /sys/class/rtc/rtc0/wakealarm"  //очистка будильника
        
        sudo sh -c "echo `date '+%s' -d '+ 1 minutes'` > /sys/class/rtc/rtc0/wakealarm"  //ставим будильник
        
        cat /proc/driver/rtd
        
        sudo halt
        
        
        
2. Центральный модуль управления паркоматом

2.1 ЧРВ

        sudo hwclock -w
        //через 2-3 секунды
        sudo hwclock -r
        
Если не работает проверить:
 
        sudo nano /boot/config.txt  
        dtverlay=i2c-rtc, mcp7940x, wekup-source
        dtparam=i2c_arm=on
    
Выполнить:

        sudo raspi-config

Interface options - I2C - ON

        sudo reboot
        ping 192.168.1.21
        ssh pi@192.168.1.21
        sudo i2cdetect -y 1
        sudo hwclock -r
               
2.2 Прошивка

        sudo nano /boot/config.txt
        dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0
        
        sudo nano /usr/local/etc/avrdude.conf
         айти id = "linuxpi"; заменить reset 25 на 5; baudrate 400000 на 12000
        
        ./flash13 t13pm.hex     
        sudo halt


3. Спутник А (файлы требуемые для выполнения wan.sh: libqmi-utils udhcpc)
        
3.1 ЧРВ
        
        sudo hwclock -w
        //через 2-3 секунды
        sudo hwclock -r
 
 Если не работает проверить:
        
        sudo nano /boot/config.txt  
        dtverlay=i2c-rtc,ds1307
        dtparam=i2c_arm=on
    
Выполнить:

        sudo raspi-config

Interface options - I2C - ON

        sudo reboot
        ing 192.168.1.21
        ssh pi@192.168.1.21
        sudo i2cdetect -y 1
        sudo hwclock -r      
 
 3.2 Прошивка 

        sudo nano /boot/config.txt
        //dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0
        
        sudo nano /usr/local/etc/avrdude.conf
        // найти id = "linuxpi"; заменить reset 25 на 5; baudrate 400000 на 12000
        
        cd /7600              
        ./install.sh            
 
3.3. Проверка модема sim7600      
        
         minicom -D /dev/ttyUSB2
                ATI             //выдает пареметры
                AT+CUSBADB=1    // выдает OK
                AT+CRESET       //система перезагружается

        ./wan.sh                //Подключение к интернету
        // в выводе скрипта идет информация о wwan0 интерфейсе с ip адресом 8,10,12 сети (не 100 и более)
        // для полной проверки мы запускаем 
        ping 8.8.8.8 -I wwan0
        
Если не получилось:
Проверить воткнут ли USB.

        ls /dev/ttyUSB*         //должен показывать от 5-ти выходов
        
Если USB есть заходим:

        minicom -D /dev/ttyUSB2
             AT+CREG?        //Ответ отличный от 0,1 - проблема с sim-картой, антеной и тд.
                
3.4. Проверка многофункционального светодиода

        raspi-gpio set 4 op dh //вкл
        raspi-gpio set 4 op dl //выкл
      
4. Мезонинная плата "Мезонин Duo" (2-х симочная) для "Умный двор" (Smart gate)

4.1. Проверка пинов    
        
        // Ключи камеры слева направо. Потухает/гаснет
        raspi-gpio set 6 op dl //выкл
        raspi-gpio set 6 op dh //вкл  
        raspi-gpio set 13 op dl 
        raspi-gpio set 13 op dh  
        raspi-gpio set 26 op dl 
        raspi-gpio set 26 op dh  
        
        //Ключ вентилятора. Запускается
        raspi-gpio set 18 op dh //вкл  
        raspi-gpio set 18 op dl //выкл
        
        //Коммутатор. Переключить кабель езернет на Расбери
        raspi-gpio set 5 op dl //выкл
        raspi-gpio set 5 op dh //вкл
        
        //Сухие контакты. Проверять с мультиметром. Без питания не пищит, с питание пищит. 
        //Переставлять клемму. Слева напрво
        raspi-gpio set 16 op dh //вкл  
        raspi-gpio set 16 op dl //выкл
        raspi-gpio set 23 op dh //вкл  
        raspi-gpio set 23 op dl //выкл
        
4.2 GSM модуль         

Подключить антену к модулю

        minicom -D /dev/ttyS0
                ATI 
                AT+IPR=115200   //Установили скорость
                AT&W            //Сохранили в память
                AT+CREG?        //Зарегестрирован ли модуль. Должно быть 0,1
                AT+CMGF=1       //Перевод режима обмена смс из кодового режима в текстовый
                AT&W            //Сохранение данных
                ATD+7<свой номер телефона>;      //Должен позвонить на телефон
                
Перезвонить ему и пока идёт звонок в minicom написать:
                
                ATH             //Должен сбросить звонок
                AT+CPOWD=1      //Должен выдать Ready 

4.3. Прошивка 

                ./flash smartgate.hex
                sudo halt
                
4.4 Преферийный процессор от mega328p           
        
        sudo dtparam spi=on     //Включили spi
        ./test_atm              //Запустили файл выполнения проверки. 
                                //Ответы везде должны быть ОК
                                //Последний параметр это пароль
  
Отправить с телефона на него смс с паролем. Устройство должно перезагрузится
