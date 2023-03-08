# FAQ

Составлен по материалам Telegram каналов `OpenIPC software` и
`OpenIPC modding`

## Cодержание

### Оригинальная прошивка камер Xiongmai

- [Как включить Telnet сервер?](#activate_telnet)

- [Как установить пароль на Telnet?](#telnet_pwd)

- [Как установить заблокированный setenv в U-Boot](#setenv)

- [Что такое Sofia?](#Sofia)

- [Если ли способы управлять камерой с помощью закрытого китайского
    протокола?](#netsdk)

- [В каком формате записывать звук для камеры?](#sound)

### Хакинг

- [Делаю killall Sofia, через некоторое время камера уходит в reboot](#watchdog)

- [Как сделать полноразмерный webcapture?](#fullcapture)

### Софт

- [Как измерить температуру чипа](#temperature)

### Железо

- [Подскажите тип разъемов на плате для подключения кабелей?](#jack)

- [Советы по PoE](#poe)

- [Как работает инфракрасная подсветка?](#ir)

- [Как работать с Ethernet из U-Boot?](#mii)

- [Зачем нужна поролоновая втулка на объективе?](#lenss)

## Как включить Telnet сервер? <a name="activate_telnet"></a>

Самый простой вариант: подключить любой serial USB-UART адаптер к камере к UART
коннектору, перегрузить ее по питанию, нажать Ctrl-C для выхода
в консоль U-Boot и ввести команду:

```
setenv telnetctrl 1; saveenv
```

Конечно, это потребует разбора корпуса камеры, наличия адаптера и необходимости
работы с проводами. Есть альтернативный способ с модификацией прошивки без
разбора камеры (но тем не менее не предназначенный для новичков), [описанный в
англоязычной
статье](https://github.com/OpenIPC/camerasrnd/blob/master/get_telnet.md).

## Как установить пароль на Telnet? <a name="telnet_pwd"></a>

Без перепрошивки этого сделать нельзя, но Telnet в камерах XM уже практически
безопасный, за исключением того, что кто-то попадет в локалку.
Но на своих камерах, конечно же везде мод прошивка и поменяны все пароли :)

(c) Dmitry Ermakov

## Как установить заблокированный параметр setenv в U-Boot? <a name="setenv"></a>

Иногда случается, что на уровне U-Boot производитель блокирует установку тех или
иных параметров (например, на камерах XM иногда нельзя изменить `xmuart`).

Для включения, я, например, делаю `printenv`, сохраняю в файл, добавляю туда
`xmuart=0`. Потом `mkenvimage -s 0x10000 -o u-boot.env.img env.txt` и через
`loady` или любым способом заливаю и подменяю энв.

(c) Dmitry Ermakov

## Что такое Sofia? <a name="Sofia"></a>

Это жирный исполняемый файл, который в лучших традициях статей про антипаттерны
программирования поддерживает весь функционал камеры, начиная со встроенного
DHCP клиента, заканчивая RTSP сервером и собственным протоколом управления.

Изначально китайцы скопипастили все с Dahua, у них этот бинарник назывался
Sonia, у XM стал Sofia.

(c) Max

## Если ли способы управлять камерой с помощью закрытого китайского протокола?
<a name="netsdk"></a>

Есть ряд наработок:

* [Python-DVR](https://github.com/NeiroNx/python-dvr), поддерживает обновление прошивок

* https://github.com/667bdrm/sofiactl

* https://github.com/alexshpilkin/dvrip

* [github.com/johndoe31415/numenworld-ipcam](https://github.com/johndoe31415/numenworld-ipcam/blob/master/nwipcam)

* [NetSDK для C#](https://github.com/QuantMad/WinNetSDK)

## Делаю killall Sofia, через некоторое время камера уходит в reboot
<a name="watchdog"></a>

Ты можешь просто выгрузить модуль watchdoga, например `rmmod xm_watchdog`

(c) Sergey Sharshunov

## Как сделать полноразмерный webcapture? <a name="fullcapture"></a>

```diff
--- ./orig/HI3516EV300_IPC_85H50AI_LIBXMCAP.json        2020-06-11 16:58:06.446462210 +0300
+++ ./HI3516EV300_IPC_85H50AI_LIBXMCAP.json     2020-06-11 21:45:16.978003244 +0300
@@ -230,8 +230,8 @@
                                "VencMode":
                                [
                                        {
-                                               "VpssChn": 2,
-                                               "EncCapSizeSrcs": ["HD1"],
+                                               "VpssChn": 1,
+                                               "EncCapSizeSrcs": ["720P"],
                                        }
                                ]
                        },
```
Теперь с webcapture.jpg отдает картинку 2592х1944, тестировалось на
EV300+IMX335.

(c) Dmitry Ermakov

## Что такое крипта?

Это применительно к камерам от XM. Раньше персональные настройки (тип сенсора,
таблица режимов, MAC адрес) хранились в отдельной микросхеме - крипто-памяти,
отсюда и название.

Потом криптопамять заменили на EEPROM, а в последнее время вообще отказались от
отдельной микросхемы, храня "крипту" прямо в основной флешке.

Если эту инфу затереть, то у камеры станет дефолтный MAC адрес, а также родной
софт не будет кодировать видео, так как не знает, в каком режиме нужно работать.
По структуре крипты известно пока мало, есть алгоритм её шифрования, известно,
где хранится MAC и как его поменять. А про остальные параметры есть только
догадки.

Перед экспериментами с прошивкой можно также сделать через в CMS или IE
экспорт конфигурации, в полученном файле найти `__tempinfo` и дальше
можно спокойно все стирать. Это резервная копия крипты, но здесь нужно от
каждого байта отнять "9", чтобы в итоге было D2 D4.

Крипта находится в последних 1024 байтах boot раздела (до env). Сигнатура крипты
2 байта 0xD2D4.  При обновлении U-Boot на другую (например, последнюю версию),
вы не оставите пользователю дороги обратно: затерев U-Boot вы потеряете
"крипту", которая сейчас хранится в самом конце загрузчика перед env. Надо или
прописывать загрузчик так, чтобы возвращать "крипту" на место, или где-то её
бэкапить.

(c) Igor Zorin

> А кем она используется? Софией?

Можно сказать, что до запуска Софии, там уже есть shared mem с HWID -
практически основной полезной информацией из крипты на сегодняшний день, все это
делают вкомпиленные ядрённые модули

Существует возможность [сгенерировать крипту, задав новый MAC
адрес](https://github.com/nikitos1550/XM_ipcam_crypto_generator) (тестировалось
на hi3516cv100/hi3518cv100).

## Как из телнета сбросить пароль на камеру?

`rm /mnt/mtd/Config/Account*`

## Как сделать дамп оригинальной прошивки?

https://zftlab.org/pages/2018020100.html

Совет по ссылке выше не подходит для новых U-boot версии 2016 года, у которых
удалена возможность выгрузки прошивки. См. совет ниже

## Можно ли слить образ при запущенной системе?

`cat /dev/mtdblock[x] > /tmp/mtdx`
и тд
у вас будет энное количество разделов, все сохранить и получите образ всего

Скрипт для получения полного образа flash в одном файле:

```sh
mount -t nfs -o nolock serverip:/srv/nfs
cd /utils
MAX=$(ls -1r /dev/mtdblock* | head -n 1 | sed 's/[^0-9]*//g')
echo -ne >ff.img
i=0
while [ "$i" -le "$MAX" ]; do
    echo "Dump $i part"
    cat /dev/mtdblock$i >> ff.img
    i=$((i+1))
done
sync
```

То же самое, но сохранить в разные файлы для разных разделов:

```sh
mount -t nfs -o nolock serverip:/srv/nfs
cd /utils
MAX=$(ls -1r /dev/mtdblock* | head -n 1 | sed 's/[^0-9]*//g')
i=0
while [ "$i" -le "$MAX" ]; do
    NAME=`grep mtd$i: /proc/mtd | awk '{gsub(/"/, "", $4); print $4}'`   
    echo "Dump $NAME"
    cat /dev/mtdblock$i >> $NAME.img
    i=$((i+1))
done
sync
```

## Как восстановить оригинальную прошивку?

Найдите последнюю прошивку для своей платы с сайта
https://www.cctvsp.ru/articles/vosstanovlenie-proshivki-i-sbros-parolya скачайте
Распакуйте на отдельные файлы. Прошивка - это zip архив
Положите их на TFTP и выполните команды, приведенные ниже:

```
setenv serverip 192.168.1.254; sf probe 0; sf lock 0; run dc; run dr; run du; run dw; reset
```

Еще один источник прошивок https://www.cctvsp.ru/articles/obnovlenie-proshivok-dlya-ip-kamer-ot-xiong-mai

## Как измерить температуру чипа <a name="temperature"></a>

`Hi3516CV200 / Hi3518EV200 / Hi3518EV201`
```sh
devmem 0x20270110 32 0x60FA0000 ; devmem 0x20270114 8  | awk '{print "CPU temperature: " ((($1)*180)/256)-40}'
```

`Hi3516CV300 / Hi3518EV100`
```sh
devmem 0x1203009C 32 0x60FA0000 ; devmem 0x120300A4 16 | awk '{print "CPU temperature: " (((($1)-125.0)/806)*165)-40}'
```

`Hi3516EV200 / Hi3516EV300`
```sh
devmem 0x120280B4 32 0xC3200000 ; devmem 0x120280BC 16 | awk '{print "CPU temperature: " (((($1)-117)/798)*165)-40}'
```

`Hi3536D`
```sh
himm 0x0120E0110 0x60320000 > /dev/null; himm 0x120E0118 | awk '{print $4}' | dd skip=1 bs=7 2>/dev/null | awk '{print "0x"$1}' | awk '{print "CPU temperature: " (($1*180)/256)-40}'
```

`Hi3536CV100`
```sh
himm 0x0120E0110 0x60320000 > /dev/null; himm 0x120E0118 | awk '{print $4}' | dd skip=1 bs=7 2>/dev/null | awk '{print "0x"$1}' | awk '{print "CPU temperature: " (($1-125)/806)*165-40}'
```

`HI3520DV200 `
```sh
devmem 20060020 32
```

`Hi3516AV200`
```sh
#PERI_PMC68 0x120a0110 (disable-->enable)
himm 0x120a0110 0 > /dev/null;
himm 0x120a0110 0x40000000 > /dev/null;

usleep 100000
#PERI_PMC70 0x120a0118 read temperature
DATA0=$(himm 0x120a0118 0 | grep 0x120a0118)
DATA1=$(printf "$DATA0" | sed 's/0x120a0118: //')
DATA2=$(printf "$DATA1" | sed 's/ --> 0x00000000//')

let "var=$DATA2&0x3ff"
if [ $var -ge 125 -a $var -le 931 ];then
    echo `awk -v x="$var" 'BEGIN{printf "chip temperature: %f\n",(x-125)*10000/806*165/10000-40}'`
else
    echo "$var ---> invalid. [125,931]"
fi
```

## Подскажите тип разъемов на плате для подключения кабелей? <a name="jack"></a>

У Molex - это серия `PicoBlade` с шагом 1.25 мм для коннекторов на платах камер
и 2.0 мм для коннекторов на LED подсветке. На Али/Тао они также известны как
разъемы `JST 1.25`, это китайский производитель и они в свое время скопировали
PicoBlade (Точнее японская компания с производством в Китае). Фактически
китайские продавцы выставляют Ckmtw(Shenzhen Cankemeng)  и HR(Joint Tech Elec).
JST и Molex оригинал стоят один как 10 шт. разъемов на Али.

(c) Maxim Gatchenko

> Можно ли самостоятельно обжимать такие коннекторы?

Инструмент стоит очень дорого, проще тысячу таких кабелей купить. Когда очень
сильно надо - я напаиваю, т.к. вручную все эти обжимки долго не живут.  Если
размер позволяет - то сначала зажимаю вручную хоть как-то, а потом уже паяю.

(c) Dmitry Ermakov

## Как сразу включить DHCP при обновлении?

`echo 1 > /mnt/mtd/Config/dhcp.cfg`

Камеру перезагружать не надо и Sofia подхватит настройки и запомнит

## Как грохнуть все настройки в дефолт?

...надо зайти на камеру телнетом и грохнуть все настройки в дефолт

rm -rf /mnt/mtd/*

и перезагрузить

# Как посмотреть логи энкодера?

```
echo "all=5" > /proc/umap/logmpp # более детальный лог

cat /dev/logmpp
cat /proc/umap/sys
cat /proc/umap/vi
cat /proc/umap/vpss
cat /proc/umap/venc
cat /proc/umap/logmpp
cat /proc/umap/isp
cat /proc/media-mem
```

Если хочется реалтаймовые логи:

```
echo "all=9" > /proc/umap/logmpp
cat /dev/logmpp
```

За подробным описанием данных в этих файлах обратитесь к разделу `12 Proc
Debugging Information` из `HiMPP IPC V3.0 Media Processing Software Development
Reference`.

## Как примонтировать образ jffs2 системы на машине разработки?

```
sudo modprobe mtdram total_size=131072 erase_size=128
sudo modprobe mtdblock
sudo dd if=rootfs_hi3516cv300_128k.jffs2 of=/dev/mtdblock0
sudo mount -t jffs2 /dev/mtdblock0 /mnt
```

## В каком формате записывать звук для камеры? <a name="sound"></name>

```
sox input.mp3 -t al -r 8000 -c 1 -b 8 output.alaw
```

(с) Dmitry Ermakov

## Советы по PoE <a name="poe"></a>

На 12В лучше не использовать коннекторы RJ-45, пригорят - токи в 4 раза больше, чем на 48В

## Как работает инфракрасная подсветка? <a name="ir"></a>

Камера ИК подсветкой не управляет, подсветка управляет камерой. Т.е. по третьему
проводу на камеру сигнал идёт, что темно стало, когда фоторезюк затемняется и
включается подсветка, а на камере в свою очередь фильтр переключается.

Для переключения режима ночь/день по датчику на подсветке следует в настройках
включить пункт "ИК-фильтр" в режим "ИК-синхронизация" вместо "автоматически"

## Как работать с Ethernet из U-Boot? <a name="mii"></a>

Годная вводная [статья](https://gahcep.github.io/blog/2012/07/24/u-boot-mii/) по
теме.

Обратите внимание, что если на команду `mii device` U-Boot не выдает никаких
устройств, то достаточно сделать `ping` на любой адрес (неважно существует он
или нет), это приведет к инициализации устройства и после этого команды должны
заработать.

## Зачем нужна поролоновая втулка на объективе? <a name="lenss"></a>

Защищает его от засветки, нарезать можно от теплоизоляции для трубок
кондиционера, да хоть из губки кухонной.

## Трансляция видео в YouTube через ffmpeg и использование его как DVR

Vasiliy, [21 Feb 2020 at 18:57:36]:
Кароче суть такая:
1. ФФмпег транслирует видео
2. Если никто не смотрит - ютуб не пишет.
3. Максимальное время записи ютуба - 12 часов (глупо это время не использовать!)
4. Ютуб начинает писать если есть хоть 1 юзер на канале. И прекращает после 30 минут после того как последний вышел
5. Есть скрипт - который по вставке ссылки с ютуба - эмулирует просмотр 5 секундный и ютуб продолжает писать следующие 30 минут
6. Вы в своей системе в кронтабе прописываете команду курл - или аналогично которое открывает эту страничку: http://cloud.vixand.com/service/youtube/stream.php?key=ххххххххх и выполняете ее раз в 28 минут

профит

## Известные проблемы

### После обновления камера получила дефолтный адрес и постоянно перезапускается

Заход на камеру через telnet показал, что `Sofia` не запущена, более того, при
ручном запуске из консоли она падает с ошибкой:

```
CMedia::start() $Rev: 972 $>>>>>
sched set 98, 2
src/HiSystem.c(1461) [HisiSysInit]: LibHicap Compiled Date: Nov 26 2018, Time: 15:49:09.
src/HiSystem.c(1474) [HisiSysInit]: g_stDevParam.bVpssOnline:0 [0 offline; 1 online].
Segmentation fault
```

Запускаем `Sofia` под strace и находим:

```
open("/mnt/mtd/Config/SensorType.bat", O_WRONLY|O_CREAT|O_TRUNC, 0666) = -1 ENOENT (No such file or directory)
--- SIGSEGV {si_signo=SIGSEGV, si_code=SEGV_MAPERR, si_addr=0x48} ---
+++ killed by SIGSEGV +++
Segmentation fault
```

Проверяем и оказывается, что раздел /mnt/mtd не смонтирован:

```
$ mount|grep /mnt/mtd
```

Пробуем смонтировать вручную:

```
$ mount -t jffs2 /dev/mtdblock5 /mnt/mtd
mount: mounting /dev/mtdblock5 on /mnt/mtd failed: Input/output error
```

В выводе `dmesg` будет нечто подобное:

```
fs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000000: 0xd4c5 instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000004: 0x3f7c instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000008: 0x37fc instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0000000c: 0x5d6b instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000010: 0xc45b instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000014: 0x9a6f instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000018: 0x80df instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0000001c: 0x7cb7 instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000020: 0xf5cd instead
jffs2: jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00000024: 0xe587 instead
jffs2: Further such events for this erase block will not be printed
jffs2: Old JFFS2 bitmask found at 0x00001ee4
```

Решение: нужно стереть этот раздел на флеш или заполнить его 0xff. См. следующий
вопрос

(с) Dmitry Ermakov

## Как стереть раздел на flash

Смотрим `/proc/cmdline` и определяем размер раздела, например

```
# cat /proc/cmdline 
init=linuxrc mem=56M console=ttyAMA0,115200 root=/dev/mtdblock1 rootfstype=squashfs mtdparts=hi_sfc:0x30000(boot),0x2E0000(romfs),0x300000(user),0x160000(web),0x40000(custom),0x50000(mtd)
```

`0x50000` - искомое значение

Теперь надо посчитать адрес его начала. При условии, что у нас флеш 8Mb
(0x800000) и mtd раздел находится в самом конце носителя искомое смещение будет
`0x800000-0x50000 = 0x7b0000`

Нужно будет в U-Boot выполнить команду `sf probe 0; sf lock 0; sf erase 7b0000
50000` для удаления содержимого раздела.

(с) Dmitry Ermakov

Если есть лог загрузки ядра там можно подсмотреть смещения разделов:

```
[    0.813360] Creating 5 MTD partitions on "hi_sfc":
0x000000000000-0x000000080000 : "boot"
0x000000080000-0x0000000c0000 : "env"
0x0000000c0000-0x0000004c0000 : "kernel"
0x0000004c0000-0x0000009c0000 : "rootfs"
0x0000009c0000-0x000001000000 : "rootfs_data"
```

(c) Sergey Sharshunov

Если нет доступа к U-Boot (есть telnet, но нет UART), можно собрать
`flash_eraseall` из состава SDK `package/board_uclibc` и выполнить очистку
раздела командой:

```sh
/utils/flash_erase /dev/mtd5 0 0
```

, где `/dev/mtd5` - определенный ранее раздел.
