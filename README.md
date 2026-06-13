<img width="885" height="572" alt="image" src="https://github.com/user-attachments/assets/d1fae5c6-ed04-4252-9f54-b8ed73b446b3" /># stud-devops_lab1
Скрипт получает текущую погоду через API Open-Meteo и генерирует HTML-страницу с информацией о температуре, влажности и скорости ветра.

Для запуска сервиса на Ubuntu 24.04 установить пакеты:
```
sudo apt install -y curl jq nginx cron
```
Склонировать репозиторий, выдать права на запуск
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
sudo -i
```
```
crontab -e
* * * * * /srv/stud-devops_lab1/pogoda_scrypt.sh"
```

После запуска скрипта будет доступна страница по адресу
http://IP_WEB-SERVER/

<img width="1027" height="411" alt="1" src="https://github.com/user-attachments/assets/edda280c-8be7-4c69-9e32-0fd770d9ec93" />
<img width="1143" height="443" alt="2" src="https://github.com/user-attachments/assets/c3c8e493-92d8-40ae-81ba-f07a7aeff8b8" />
