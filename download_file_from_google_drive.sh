#!/bin/bash

# Что бы преобразовать ссылку на файл с гугл диска для скачивания с помощью wget, нужно в https://drive.google.com/uc?export=download&id= добавить id
# нужного файла, полученный из ссылки на файл, которую даёт сам гугл диск. Например:
# Ссылка на файл, которую даёт гугл диск: https://drive.google.com/open?id=1LXDrudeRmWhnS4akgljAukysZf4lqfhR
# Ссылка для wget: https://drive.google.com/uc?export=download&id=1LXDrudeRmWhnS4akgljAukysZf4lqfhR

# Если предыдущий вариант не работает (скорее всего по причине того, что файл очень большой), нужно использовать:
# wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt 
# --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O- | sed -rn 
# 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=FILEID" -O FILENAME && rm -rf /tmp/cookies.txt
# Где FILEID заменить на id файла (который следует после id= в ссылке на файл, которую даёт гугл диск),
# а FILENAME - на имя, под которым будет сохранён скачаный файл.

function echo_help() {
    echo -e "\nВыполняет загрузку файла любого размера из Google Drive по указанной ссылке общего доступа. Извлекает из ссылки id файла, подставляет его в \
'https://drive.google.com/uc?export=download&confirm=\$CONFIRM&id=\$FILE_ID' и загружает с помощью wget."

    echo -e "\nИспользование: download_file_from_google_drive.sh [-h|--help] url"

    echo -e "\nПоддерживаемые аргументы:"
    echo -e "\t url \t\t - ссылка общего доступа на файл в Google Drive (рекомендуется указывать ссылку в кавычках)"
    echo -e "\t -h, --help \t - показать эту справку"

    echo -e "\nПример:"
    echo -e "\t ./download_file_from_google_drive.sh \"https://drive.google.com/open?id=1hiDnK6vbfSBgGafWVrrK_WAP2gx8G4h3\"\n"
}

if [ -n "$1" ]; then
    case "$1" in
        "-h") echo_help
            exit 0;;
        "--help") echo_help
            exit 0;;
    esac
else
    echo_help
    exit 0
fi

FILE_ID=$(echo $1 | grep -o "id=.*" | cut -f 2 -d "=" | cut -f 1 -d "&")
echo -e "\nFound file id: $FILE_ID"
echo -e "Downloading...\n"

#wget --content-disposition "https://drive.google.com/uc?export=download&id=$FILE_ID"
CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$FILE_ID" -O- | sed -rn "s/.*confirm=([0-9A-Za-z_]+).*/\1\n/p")
wget --content-disposition --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$FILE_ID" && rm /tmp/cookies.txt

if [ $? -ne 0 ]; then
    echo -e "Fail!\n"
else
    echo -e "Done.\n"
fi
