# stud-devops_lab1
Скрипт получает актуальную погоду через API Open-Meteo и создает страницу с информацией о температуре, влажности и скорости и направлении ветра.

Для запуска сервиса на Ubuntu 24.04(minmal) нужно установить пакеты:
```
sudo apt install -y curl jq nginx cron git
```
Склонировать репозиторий c git, выдать права на запуск
```
git clone https://github.com/SoulEra/stud-devops_lab1
```
```
chmod +x pogoda_scrypt.sh
```
```
sudo mv stud-devops_lab1 /srv/
```

Добавить задачу в крон для запуса каждую минуту
```
sudocrontab -e
```
И добавить строчку:
```
* * * * * /srv/stud-devops_lab1/pogoda_scrypt.sh"
```

После запуска скрипта будет доступна страница по адресу
http://IP_WEB-SERVER/

<img width="1027" height="411" alt="1" src="https://github.com/user-attachments/assets/edda280c-8be7-4c69-9e32-0fd770d9ec93" />
<img width="1143" height="443" alt="2" src="https://github.com/user-attachments/assets/c3c8e493-92d8-40ae-81ba-f07a7aeff8b8" />
