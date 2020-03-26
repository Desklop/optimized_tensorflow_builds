#!/bin/bash

XLA="-XLA"
GPU=""
MKL=""

# Функция для вывода инструкции по использованию
function echo_help() {
    echo -e "\nОпределяет поддерживаемые текущим CPU инструкции, версию Python и CUDA, выбирает наиболее подходящую версию TensorFlow, загружает её \
из Google Drive (папка со всеми доступными версиями: https://drive.google.com/open?id=1rCAwqxlsEmqFCXHKkZCu3X5AOoa6Iz6o) и устанавливает. Если подходящей \
версии TensorFlow не найдено, будет установлена версия из pip."
    echo -e "Внимание! Все доступные версии TensorFlow собраны с поддержкой XLA-JIT!"
    
    echo -e "\nИспользование: install_custom_tensorflow_v1.15.2.sh [-gpu|-mkl|-h|--help]"

    echo -e "\nПоддерживаемые аргументы:"
    echo -e "\t -gpu \t\t - загрузить и установить версию с поддержкой GPU"
    echo -e "\t -mkl \t\t - загрузить и установить версию с поддержкой Intel MKL-DNN"
    echo -e "\t -h, --help \t - показать эту справку"

    echo -e "\nПример:"
    echo -e "\t ./install_custom_tensorflow_v1.15.2.sh -gpu -mkl\n"
}

# Разбор аргументов командной строки
while [ -n "$1" ]; do
    case "$1" in
        "-xla") XLA="-XLA" ;;
        "-gpu") GPU="-GPU" ;;
        "-mkl") MKL="-MKL" ;;
        "-h") echo_help; exit 0;;
        "--help") echo_help; exit 0;;
    esac
    shift
done




# Получение списка поддерживаемых текущим CPU инструкций
ALL_CPU_INSTRUCTIONS=("sse4.1" "sse4.2" "avx" "avx2" "fma" "avx512f")
CPU_INSTRUCTIONS=($(cat /proc/cpuinfo | grep -m 1 flags | grep -o "sse4_1\s\|sse4_2\s\|avx\s\|avx2\s\|fma\s\|avx512f\s" | sed "s/_/./g" | sed "s/\s//g"))
SUPPORTED_CPU_INSTRUCTIONS=""

# Если длина массива найденных инструкций равна длине массива со всеми известными инструкциями - используем постфикс "-ALL"
if [ ${#CPU_INSTRUCTIONS[@]} -eq ${#ALL_CPU_INSTRUCTIONS[@]} ]; then
    SUPPORTED_CPU_INSTRUCTIONS="-ALL"
fi

# Если длина массива найденных инструкций равна 0 - используем постфикс "-noALL"
if [ ${#CPU_INSTRUCTIONS[@]} -eq 0 ]; then
    SUPPORTED_CPU_INSTRUCTIONS="-noALL"
fi

# Если длина массива найденных инструкций больше 0 и меньше длины массива со всеми известными инструкциями
if [[ -z $SUPPORTED_CPU_INSTRUCTIONS ]]; then
    # Определение числа элементов в массиве найденных инструкций, после которого переходить в постфиксе с перечисления найденных инструкций
    # на перечисление отсутствующих инструкций (вычисляется как "половина длины массива со всеми известными инструкциями + 1")
    LIMIT=$(expr ${#ALL_CPU_INSTRUCTIONS[@]} - ${#ALL_CPU_INSTRUCTIONS[@]} / 2 + 1)

    # Если число найденных инструкций больше или равно "границе перехода"
    if [ ${#CPU_INSTRUCTIONS[@]} -ge $LIMIT ]; then
        # Поиск отсутствующих инструкций
        for found_instruction in ${CPU_INSTRUCTIONS[@]}; do
            for i in ${!ALL_CPU_INSTRUCTIONS[@]}; do
                if [ ${ALL_CPU_INSTRUCTIONS[$i]} = $found_instruction ]; then
                    unset ALL_CPU_INSTRUCTIONS[$i]
                fi
            done
        done
        
        # Сохранение отсутствующих инструкций в постфикс
        for not_found_instruction in ${ALL_CPU_INSTRUCTIONS[@]}; do
            SUPPORTED_CPU_INSTRUCTIONS+="-no${not_found_instruction^^}"
        done
    else
        # Сохранение найденных инструкций в постфикс
        for found_instruction in ${CPU_INSTRUCTIONS[@]}; do
            SUPPORTED_CPU_INSTRUCTIONS+="-${found_instruction^^}"
        done
    fi
fi

# Что бы флаг FMA был в конце списка инструкций, а не в начале (просто для красоты)
if [[ -n $(echo $SUPPORTED_CPU_INSTRUCTIONS | grep -o "FMA") ]] >> /dev/null; then
    SUPPORTED_CPU_INSTRUCTIONS=$(echo $SUPPORTED_CPU_INSTRUCTIONS | sed "s/-FMA//")
    SUPPORTED_CPU_INSTRUCTIONS+="-FMA"
fi

if [[ -n $GPU ]]; then
    # Определение версии CUDA
    CUDA_VERSION=$(nvcc -V | grep -o "release [0-9]\{1,2\}\.[0-9]" | sed "s/release //g")
    CUDA_VERSION="-cuda${CUDA_VERSION}"
    NAME="tensorflow-gpu${SUPPORTED_CPU_INSTRUCTIONS}${CUDA_VERSION}${MKL}${XLA}"
else 
    NAME="tensorflow-cpu${SUPPORTED_CPU_INSTRUCTIONS}${MKL}${XLA}"
fi

# Что бы имя не отличалось от присвоенного пакету (bazel в названии проекта все '-' заменяет на '_')
NAME=$(echo $NAME | sed "s/-/_/g")
PYTHON3_VERSION=$(python3 -V | grep -o "[0-9]\.[0-9]" | sed "s/\.//g")
WHEEL_NAME="${NAME}-1.15.2-cp${PYTHON3_VERSION}-cp${PYTHON3_VERSION}m-linux_x86_64.whl"
echo -e "\nDefined wheel: '${WHEEL_NAME}'"




# Функция для загрузки файла из Google Drive по его id, который можно получить из ссылки для общего доступа
function download_file_from_google_drive() {
    FOUND_FILE_ID=$1
    echo -e "Found. Downloading...\n"

    CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$FOUND_FILE_ID" -O- | sed -rn "s/.*confirm=([0-9A-Za-z_]+).*/\1\n/p")
    wget --content-disposition --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$CONFIRM&id=$FOUND_FILE_ID" && rm /tmp/cookies.txt
    
    if [ $? -ne 0 ]; then
        echo -e "Fail!\n"
        exit 1
    else
        echo -e "Done."
    fi
}

# Поиск подходящего для конкретной машины пакета TensorFlow
# https://drive.google.com/open?id=1a24_GHdICZwjCHQjnUhWMzoaJnaN_-ob
if [[ $WHEEL_NAME = "tensorflow_cpu_ALL_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "1a24_GHdICZwjCHQjnUhWMzoaJnaN_-ob"
fi

# https://drive.google.com/open?id=1Q6JiBL7Xw2kl4FIiyibPWuhHw-vWHzSD
if [[ $WHEEL_NAME = "tensorflow_gpu_ALL_cuda10.0_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "1Q6JiBL7Xw2kl4FIiyibPWuhHw-vWHzSD"
fi

# https://drive.google.com/open?id=11hNyzx-C7M5MfdwgvMitflZg5kPKM4jg
if [[ $WHEEL_NAME = "tensorflow_gpu_ALL_cuda10.2_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "11hNyzx-C7M5MfdwgvMitflZg5kPKM4jg"
fi

# https://drive.google.com/open?id=1fCUg4DNa_GZj9aWnbqR1GYyqD17G1866
if [[ $WHEEL_NAME = "tensorflow_cpu_noAVX512F_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "1fCUg4DNa_GZj9aWnbqR1GYyqD17G1866"
fi

# https://drive.google.com/open?id=1u-jIs0lrxG9TDKZoIpYTsCF-b_AKWAB8
if [[ $WHEEL_NAME = "tensorflow_gpu_noAVX512F_cuda10.0_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "1u-jIs0lrxG9TDKZoIpYTsCF-b_AKWAB8"
fi

# https://drive.google.com/open?id=1PtKLxyl_cmukRJrdrVznUiYmE7P2kxRz
if [[ $WHEEL_NAME = "tensorflow_gpu_noAVX512F_cuda10.2_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "1PtKLxyl_cmukRJrdrVznUiYmE7P2kxRz"
fi

# https://drive.google.com/open?id=1zR5G-8QDZSnXzF2_mJ9p7GsmXV2FEWOm
if [[ $WHEEL_NAME = "tensorflow_cpu_SSE4.1_SSE4.2_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "1zR5G-8QDZSnXzF2_mJ9p7GsmXV2FEWOm"
fi

# https://drive.google.com/open?id=1Cos4GYQLM2YsdkHmr785qKCR_CX6mkBl
if [[ $WHEEL_NAME = "tensorflow_gpu_SSE4.1_SSE4.2_cuda10.0_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "1Cos4GYQLM2YsdkHmr785qKCR_CX6mkBl"
fi

# https://drive.google.com/open?id=1aOUAtD6pa4rq1tNLUfwGg9I9ma9kxdUT
if [[ $WHEEL_NAME = "tensorflow_gpu_SSE4.1_SSE4.2_cuda10.2_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "1aOUAtD6pa4rq1tNLUfwGg9I9ma9kxdUT"
fi

# https://drive.google.com/open?id=1lC_8Zl2SYXWwHWq0IsS-N_MeoctW7FH4
if [[ $WHEEL_NAME = "tensorflow_cpu_noALL_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl" ]]; then
    download_file_from_google_drive "1lC_8Zl2SYXWwHWq0IsS-N_MeoctW7FH4"
fi




# Если пакет был найден - установка его, иначе - установка стандартного пакета из pip
if [[ -n $FOUND_FILE_ID ]]; then
    echo -e "Installing downloaded wheel with pip3...\n"
    pip3 install $WHEEL_NAME && rm $WHEEL_NAME
else
    echo -e "ERROR: definite wheel not found. Installing from pip3...\n"
    if [[ -n $GPU ]]; then
        pip3 install tensorflow-gpu==1.15.2
    else
        pip3 install tensorflow==1.15.2
    fi
fi

if [ $? -ne 0 ]; then
    echo -e "\nFail!\n"
else
    echo -e "\nDone.\n"
fi
