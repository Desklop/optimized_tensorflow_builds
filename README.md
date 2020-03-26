# Optimized TensorFlow wheels

**Репозиторий** предназначен **для хранения собранных** с помощью [данного docker-образа](https://github.com/Desklop/building_tensorflow) оптимизированных **версий TensorFlow и TensorFlow-GPU v1.13.1-1.15.2** под конкретные CPU (для повышения производительности на новых CPU и возможности запуска на старых CPU).

**Все собранные версии** TensorFlow и TensorFlow-GPU v1.13.1-1.15.2 **хранятся в** моём [Google Drive](https://drive.google.com/open?id=1rCAwqxlsEmqFCXHKkZCu3X5AOoa6Iz6o).

**Сборка** выполнялась **в ОС Ubuntu 19.10 с Python 3.6-3.7**, с поддержкой XLA и без поддержки [Intel MKL-DNN](https://software.intel.com/en-us/mkl). TensorFlow-GPU требует **CUDA 10.0-10.2 и cuDNN 7.6**, при сборке было указано **Compute Capability 6.1, 7.0 и 7.5**.

| Имя    | CPU     | Supported Instructions | GPU     |
| :----- | :-----: | :-----:                | :-----: |
| [tensorflow_cpu_ALL_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=1a24_GHdICZwjCHQjnUhWMzoaJnaN_-ob) | Intel Xeon Silver 4214 | SSE4.1, SSE4.2, AVX, AVX2, AVX512F, FMA | — |
| [tensorflow_gpu_ALL_cuda10.0_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=1Q6JiBL7Xw2kl4FIiyibPWuhHw-vWHzSD) | Intel Xeon Silver 4214 | SSE4.1, SSE4.2, AVX, AVX2, AVX512F, FMA | NVIDIA Tesla T4 (CUDA 10.0, cuDNN 7.6.5) |
| [tensorflow_gpu_ALL_cuda10.2_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=11hNyzx-C7M5MfdwgvMitflZg5kPKM4jg) | Intel Xeon Silver 4214 | SSE4.1, SSE4.2, AVX, AVX2, AVX512F, FMA | NVIDIA Tesla T4 (CUDA 10.2, cuDNN 7.6.5) |
| [tensorflow_cpu_noAVX512F_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=1fCUg4DNa_GZj9aWnbqR1GYyqD17G1866) | Intel Core i7-10510U | SSE4.1, SSE4.2, AVX, AVX2, FMA | — |
| [tensorflow_gpu_noAVX512F_cuda10.0_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=1u-jIs0lrxG9TDKZoIpYTsCF-b_AKWAB8) | Intel Core i7-10510U | SSE4.1, SSE4.2, AVX, AVX2, FMA | NVIDIA GeForce MX250 (CUDA 10.0, cuDNN 7.6.5) |
| [tensorflow_gpu_noAVX512F_cuda10.2_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=1PtKLxyl_cmukRJrdrVznUiYmE7P2kxRz) | Intel Core i7-10510U | SSE4.1, SSE4.2, AVX, AVX2, FMA | NVIDIA GeForce MX250 (CUDA 10.2, cuDNN 7.6.5) |
| [tensorflow_cpu_SSE4.1_SSE4.2_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=1zR5G-8QDZSnXzF2_mJ9p7GsmXV2FEWOm) | Intel Xeon X5650 | SSE4.1, SSE4.2 | — |
| [tensorflow_gpu_SSE4.1_SSE4.2_cuda10.0_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=1Cos4GYQLM2YsdkHmr785qKCR_CX6mkBl) | Intel Xeon X5650 | SSE4.1, SSE4.2 | NVIDIA GeForce RTX2080 (CUDA 10.0, cuDNN 7.6.5) |
| [tensorflow_gpu_SSE4.1_SSE4.2_cuda10.2_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=1aOUAtD6pa4rq1tNLUfwGg9I9ma9kxdUT) | Intel Xeon X5650 | SSE4.1, SSE4.2 | NVIDIA GeForce RTX2080 (CUDA 10.2, cuDNN 7.6.5) |
| [tensorflow_cpu_noALL_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl](https://drive.google.com/open?id=1lC_8Zl2SYXWwHWq0IsS-N_MeoctW7FH4) | [KVM Processor](https://ru.wikipedia.org/wiki/KVM) | — | — |
| [tensorflow_i7_8700-1.13.1-cp36-cp36m-linux_x86_64.whl](https://drive.google.com/open?id=1hiDnK6vbfSBgGafWVrrK_WAP2gx8G4h3) | Intel Core i7-8700 | SSE4.1, SSE4.2, AVX, AVX2, FMA | — |
| [tensorflow_i7_8700_GeForceGTX1070-1.13.1-cp36-cp36m-linux_x86_64.whl](https://drive.google.com/open?id=1skGMKtKdf6ekhBm14KLgLBCDRId94Bcq) | Intel Core i7-8700 | SSE4.1, SSE4.2, AVX, AVX2, FMA | NVIDIA GeForce GTX1070 (CUDA 10.0, cuDNN 7.5) |
| [tensorflow_E3_1270-1.13.1-cp36-cp36m-linux_x86_64.whl](https://drive.google.com/open?id=17h4R0E-f3DFTFc_hDBkW73kIsvbyHV7h) | Intel Xeon E3-1270 v3 | SSE4.1, SSE4.2, AVX, AVX2 | — |
| [tensorflow_X5650-1.13.2-cp36-cp36m-linux_x86_64.whl](https://drive.google.com/open?id=1ND8eHg2CUdi850fFFAy1hyzUX-YYWUOb) | Intel Xeon X5650 | SSE4.1, SSE4.2 | — |
| [tensorflow_X5650_GeForceRTX2080-1.13.2-cp36-cp36m-linux_x86_64.whl](https://drive.google.com/open?id=1SXb3qZM82noZXj_IK3NKRGfH0k9G5MYH) | Intel Xeon X5650 | SSE4.1, SSE4.2 | NVIDIA GeForce RTX2080 (CUDA 10.0, cuDNN 7.5) |

---

## Варианты установки

1. **Загрузить** нужную версию **вручную и установить с помощью pip**:

```bash
pip3 install wheel_name.whl
```

2. Выбрать нужную версию, **скопировать ссылку** на неё, **загрузить скриптом** [`download_file_from_google_drive.sh`](https://github.com/Desklop/optimized_tensorflow_wheels/blob/master/download_file_from_google_drive.sh) и **установить с помощью pip** (загруженный файл после установки можно удалить):

```bash
./download_file_from_google_drive.sh "link_to_wheel"
pip3 install wheel_name.whl
rm wheel_name.whl
```

Например, версия `tensorflow_cpu_noALL_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl`:

```bash
./download_file_from_google_drive.sh "https://drive.google.com/open?id=1lC_8Zl2SYXWwHWq0IsS-N_MeoctW7FH4"
pip3 install tensorflow_cpu_noALL_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl
rm tensorflow_cpu_noALL_XLA-1.15.2-cp37-cp37m-linux_x86_64.whl
```

3. Использовать **скрипт для автоматического определения, загрузки и установки подходящей версии** [`install_optimized_tensorflow_v1.15.2.sh`](https://github.com/Desklop/optimized_tensorflow_wheels/blob/master/install_optimized_tensorflow_v1.15.2.sh):

```bash
./install_optimized_tensorflow_v1.15.2.sh [-mkl|-gpu]
```

Данный скрипт определяет поддерживаемые текущим CPU инструкции, версию Python и CUDA, выбирает наиболее подходящую версию TensorFlow, загружает её из [папки в Google Drive](https://drive.google.com/open?id=1rCAwqxlsEmqFCXHKkZCu3X5AOoa6Iz6o) и устанавливает. Если подходящей версии TensorFlow не найдено, будет установлена версия из pip.

Скрипт принимает несколько аргументов:

- `-mkl`: загрузить и установить версию с поддержкой [Intel MKL-DNN](https://software.intel.com/en-us/mkl)
- `-gpu`: загрузить и установить версию с поддержкой GPU

---

## Другие версии TensorFlow от сообщества

В репозитории [**tensorflow-community-wheels**](https://github.com/yaroslavvb/tensorflow-community-wheels) можно найти **намного больше различных версий** TensorFlow и TensorFlow-GPU, собранных другими участниками сообщества.

---

Если у вас возникнут вопросы или вы хотите сотрудничать, можете написать мне на почту: vladsklim@gmail.com или в [LinkedIn](https://www.linkedin.com/in/vladklim/).
