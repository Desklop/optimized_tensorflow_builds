#!/bin/bash

# Что бы преобразовать ссылку на файл с гугл диска для скачивания с помощью wget, нужно в https://drive.google.com/uc?export=download&id= добавить id нужного файла, полученный из ссылки на файл, которую даёт сам гугл диск. Например:
# Ссылка на файл, которую даёт гугл диск: https://drive.google.com/open?id=1LXDrudeRmWhnS4akgljAukysZf4lqfhR
# Ссылка для wget: https://drive.google.com/uc?export=download&id=1LXDrudeRmWhnS4akgljAukysZf4lqfhR

# Если предыдущий вариант не работает (скорее всего по причине того, что файл очень большой), нужно использовать: wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=FILEID" -O FILENAME && rm -rf /tmp/cookies.txt
# Где FILEID заменить на id файла (который следует после id= в ссылке на файл, которую даёт гугл диск), FILENAME - на имя, под которым будет сохранён скачаный файл

echo_help() {
    echo "Выполняет загрузку файла с Google Drive по указанной ссылке. Извлекает из ссылки id файла и подставляет в https://drive.google.com/uc?export=download&id=$ID."
    echo "Использование: [-h] [help] url"
    echo "Пример:"
    echo "./download_wheel.sh https://drive.google.com/open?id=1hiDnK6vbfSBgGafWVrrK_WAP2gx8G4h3"
}

if [ -n "$1" ]; then
    case "$1" in
        -h) echo_help
            exit;;
        help) echo_help
            exit;;
    esac
else
    echo_help
    exit
fi

ID=$(echo $1 | grep -o "id=.*" | cut -f 2 -d "=" | cut -f 1 -d "&")
echo "Found file id: $ID"
echo "Downloading..."
#wget --content-disposition "https://drive.google.com/uc?export=download&id=$ID"
CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$ID" -O- | sed -rn "s/.*confirm=([0-9A-Za-z_]+).*/\1\n/p")
wget --content-disposition --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$ID"
rm -rf /tmp/cookies.txt
echo "Done"
