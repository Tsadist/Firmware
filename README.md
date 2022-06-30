Перечень устройств и их модули:
1. Мезонинная плата "Страж солнце"
        - менеджер управления питания на основе мк ittyny13
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
        
3. Спутник А
        - ЧРВ "ds1370"
        - модем с супервизором на основе sim7600
        - многофункциональный светодиод
 
4. Мезонинная плата "Мезонин Duo" (2-х симочная) для "Умный двор" (Smart gate)
        - JSON модуль sim800
        - переферийный процессор от meha328p
        - 2 выхода "сухой контакт"
        - 3 ключа управления питанием камеры
        - ключ управления коммутатором
        - ключ управления вентилятором
        -
4.1 Мезонинная плата "Мезонин Uno" (1 симочная) для "Умный двор" (Smart gate)
        - модем с супервизором на основе sim7600
        - 2 выхода "сухой контакт"
        - 3 ключа управления питанием камеры
        - ключ управления коммутатором
        - ключ управления вентилятором
        


1. Питание

        ping 192.168.1.21

        ssh pi@192.168.1.21

2. Запуск вентилятора

        raspi-gpio set 18 op dh //включить вентилятор
 
        raspi-gpio set 18 op dl //выключить вентилятор 
 
 3. ЧРВ
 
        sudo hwclock -w
        //через 2-3 секунды
        sudo hwclock -r
 
 Если не работает:
 
    sudo nano /boot/config.txt  
    //dtverlay=i2c-rtc, mcp7940x, wekup-source
    
    
    //dtverlay=i2c-rtc,ds1370   //Спутник
    //dtparam=i2c_arm=on
    
Выполнить:

    sudo raspi-config

Interface options - I2C - ON

    sudo reboot
    ping 192.168.1.21
    ssh pi@192.168.1.21
    sudo i2cdetect -y 1
    sudo hwclock -r
    
4. Прошивка

        sudo nano /boot/config.txt
        //dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0
        
        sudo nano /usr/local/etc/avrdude.conf
        // найти id = "linuxpi"; заменить reset 25 на 5; baudrate 400000 на 12000
        
        ./flash13 t13.hex       //Страж солнце
        ./flash13 t13pm.hex     //Паркомат
        
        cd /7600                //Спутник
        ./install.sh
        ./wan.sh
        
        sudo halt
        
5. Комплексная проверка

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
      