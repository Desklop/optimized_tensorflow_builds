# Optimized TensorFlow builds

Репозиторий предназначен для хранения собранных с помощью [данного docker образа](https://github.com/Desklop/build_tensorflow) наиболее оптимизированных версий TensorFlow v1.13.1 и TensorFlow-GPU v1.13.1 под конкретные CPU и GPU для повышения производительности. Буду рад, если вы соберёте TensorFlow на своей машине и добавите его в данный репозиторий :)

Все доступные версии TensorFlow v1.13.1 и TensorFlow-GPU v1.13.1 хранятся в моём [Google Drive](https://drive.google.com/open?id=1rCAwqxlsEmqFCXHKkZCu3X5AOoa6Iz6o) и предназначены для ОС Ubuntu 18.04 и Python 3.6, и собраны без поддержки Intel MKL-DNN. TensorFlow-GPU v1.13.1 требует CUDA 10.0 и cuDNN 7.5.


| Имя           | CPU             | GPU   |
| :------------ |:---------------:|:-----:|
| [tensorflow_i7_8700-1.13.1-cp36-cp36m-linux_x86_64.whl](https://drive.google.com/uc?export=download&id=1hiDnK6vbfSBgGafWVrrK_WAP2gx8G4h3) | Intel Core i7-8700 3.2GHz×12 | не поддерживается |
| [tensorflow_i7_8700_GeForceGTX1070-1.13.1-cp36-cp36m-linux_x86_64.whl](https://drive.google.com/uc?export=download&id=1skGMKtKdf6ekhBm14KLgLBCDRId94Bcq) | Intel Core i7-8700 3.2GHz×12 | NVIDIA GeForce 1070 |
| [tensorflow_E3_1270-1.13.1-cp36-cp36m-linux_x86_64.whl](https://drive.google.com/uc?export=download&id=17h4R0E-f3DFTFc_hDBkW73kIsvbyHV7h) | Intel Xeon E3-1270 v3 3.5GHz×8 | не поддерживается |
| ... | Intel Xeon E5645 2.4GHz×12 | не поддерживается |
| ... | ... | ... |


Варианты установки:
1. Загрузить нужную версию вручную и выполнить:
```bash
sudo pip3 install wheel_name.whl
```
2. Выбрать нужную версию, скопировать ссылку на неё и выполнить (загруженный файл после установки можно удалить):
```bash
./download_wheel.sh "link_to_wheel"
sudo pip3 install wheel_name.whl
rm wheel_name.whl
```
Например, версия `tensorflow_i7_8700-1.13.1-cp36-cp36m-linux_x86_64.whl`:
```bash
./download_wheel.sh "https://drive.google.com/uc?export=download&id=1hiDnK6vbfSBgGafWVrrK_WAP2gx8G4h3"
sudo pip3 install tensorflow_i7_8700-1.13.1-cp36-cp36m-linux_x86_64.whl
rm tensorflow_i7_8700-1.13.1-cp36-cp36m-linux_x86_64.whl
```

**ВНИМАНИЕ!** Имя пакета должно быть таким же, как и в данном репозитории. Иначе pip не позволит установить его.

---

Если у вас возникнут вопросы или вы хотите сотрудничать, можете написать мне на почту: vladsklim@gmail.com или в [LinkedIn](https://www.linkedin.com/in/vladklim/).