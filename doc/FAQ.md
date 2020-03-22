# FAQ

Составлен по материалам Telegram каналов `OpenWrt for IPCam + soft` и
`ModdingIPC HI35xx`

## Что такое Sofia?

Это жирный исполняемый файл, который в лучших традициях статей про антипаттерны
программирования поддерживает весь функционал камеры, начиная со встроенного
DHCP клиента, заканчивая RTSP сервером и собственным протоколом управления.

Изначально китайцы скопипастили все с Dahua, у них этот бинарник назывался
Sonia, у XM стал Sofia.

(c) Max

## Если ли способы управлять камерой с помощью собственного протокола?

Есть ряд наработок:

* [Python-DVR](https://github.com/NeiroNx/python-dvr), поддерживает обновление
  прошивок
* https://github.com/667bdrm/sofiactl
* https://github.com/alexshpilkin/dvrip

## Делаю killall Sofia, через некоторое время камера уходит в reboot

Ты можешь просто выгрузить модуль watchdoga, например `rmmod xm_watchdog`

(c) Sergey Sharshunov

## Как включить Telnet сервер?

Подключите камеру по UART, перегрузите ее по питанию, нажмите Ctrl-C для выхода
в консоль U-Boot и введите команду:

```
setenv telnetctrl 1; saveenv
```

## Как установить пароль на Telnet?

Без перепрошивки этого сделать нельзя, но Telnet в камерах XM уже практически
безопасный, за исключением того, что кто-то попадет в локалку.
Но на своих камерах, конечно же везде мод прошивка и поменяны все пароли :)

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

```
mount -t nfs -o nolock serverip:/srv/nfs
cd /utils
MAX=`ls -lr /dev/mtdblock* | head -1 | awk '{print $10}' | sed 's/[^0-9]*//g'`
echo -ne >ff.img
i=0
while [ "$i" -le "$MAX" ]; do
    echo "Dump $i part"
    cat /dev/mtdblock$i >> ff.img
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

## Как коннектор на плате Hi35 называется?

разьемы   JST    шаг  1,25 мм
https://ru.aliexpress.com/item/32787942551.html
https://qntsq.aliexpress.ru/store/group/1-25MM-Cable/302471_509986609.html

## Как сразу включить DHCP при обновлении?

`echo 1 > /mnt/mtd/Config/dhcp.cfg`

Камеру перезагружать не надо и Sofia подхватит настройки и запомнит

## Как грохнуть все настройки в дефолт?

...надо зайти на камеру телнетом и грохнуть все настройки в дефолт

rm -rf /mnt/mtd/*

и перезагрузить

# Как посмотреть логи энкодера?

```
cat /dev/logmpp
cat /proc/umap/vpss
cat /proc/umap/venc
```

## Как примонтировать образ jffs2 системы на машине разработки?

```
sudo modprobe mtdram total_size=131072 erase_size=128
sudo modprobe mtdblock
sudo dd if=rootfs_hi3516cv300_128k.jffs2 of=/dev/mtdblock0
sudo mount -t jffs2 /dev/mtdblock0 /mnt
```
## PoE

На 12В лучше не использовать коннекторы RJ-45, пригорят - токи в 4 раза больше, чем на 48В

## Как работает инфракрасная подсветка?

Камера ИК подсветкой не управляет, подсветка управляет камерой. Т.е. по третьему
проводу на камеру сигнал идёт, что темного стало, когда фоторезюк затемняется и
включается подсветка, а на камере в свою очередь фильтр переключается

Для переключения режима ночь/день по датчику на подсветке следует в настройках
включить пункт "ИК-фильтр" в режим "ИК-синхронизация" вместо "автоматически"

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

## В каком формате записывать звук для камеры?

```
sox input.mp3 -t al -r 8000 -c 1 -b 8 output.alaw
```

(с) Dmitry Ermakov
