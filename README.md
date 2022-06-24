1. Питание

        ping 192.168.1.21

        ssh pi@192.168.1.21

2. Запуск вентилятора

        raspi-gpio set 18 op dh //включить вентилятор
 
        raspi-gpio set 18 op dl //выключить вентилятор 
 
 3. ЧРВ
 
        sudo hwclock -w

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
    sudo i2detect -y 1
    sudo hwclock -r
    
4. Прошивка

        sudo nano /boot/config.txt
        //dtoverlay=gpio-poweroff,active_low="y",gpiopin=6,input,active_delay_ms=0,inactive_delay_ms=0
        
        sudo nano /usr/local/etc/avrdude.conf
        // найти id = "linuxpi"; заменить reset 25 на 5; baudrate 400000 на 12000
        
        ./flash13 t13.hex
        
        sudo halt
        
5. Комплексная проверка

        ping 192.168.1.21
        
        ssh pi@192.168.1.21
        
        F^C flash13
        
        cat /proc/driver/rtc
        
        sudo hwclock -w  //синх-ия
        
        sudo sh -c "echo 0 > /sys/class/rtc/rtc0/wakealarm"  //очистка будильника
        
        sudo sh -c "echo date '+%s' -d '+ 1 minutes' > /sys/class/rtc/rtc0/wakealarm"  //ставим будильник
        
        cat /proc/driver/rtd
        
        sudo halt
        
