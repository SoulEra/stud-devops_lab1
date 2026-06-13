# stud-devops_lab1
Скрипт получает текущую погоду через API Open-Meteo и генерирует HTML-страницу с информацией о температуре, влажности и скорости ветра.

Для запуска сервиса на Ubuntu 24.04 установить пакеты:

sudo apt install -y curl jq nginx cron
Склонировать репозиторий, выдать права на запуск

git clone https://github.com/SoulEra/stud-devops_lab1
chmod +x pogoda_scrypt.sh
sudo mv stud-devops_lab1 /srv/

Добавить задачу в крон для запуса каждую минуту

sudo -i
crontabv -e
* * * * * /srv/stud-devops_lab1/pogoda_scrypt.sh"
        * 
После запуска скрипта будет доступна страница по адресу
http://IP_WEB-SERVER/
