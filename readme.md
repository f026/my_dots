<p> Hi! Это мои доты hyprland</p>

## Информация о репозитории
``
Данное рабочее окружение было построенно вокруг оконного менеджера hyprland на дистрибутиве cachyos.
Репозиторий включает в себя не только конфиги hyprland,но и терминала,консольного текстового редактора и fastfetch
Рабочее окружение расчитанно на два монитора.
``
## Основной софт и скрипты
* wm:`Hyprland`
* Терминал:`Alacritty`
* Меню выхода:`wlogout`(Ставил из AUR)
* Экран блокировки:`hyprlock`
* Консольный текстовый редактор:`neovim`
* Консольный мониторинг процессов:`gotop`
* Консольный двухпанельный файловый менеджер:`vifm`
* Обычный файловый менеджер:`nemo`(для браузера)
* Графическая программа для аудио:`pwvucontrol`(Ставил из AUR)
* Браузер:`zen`
* Мессенжеры:`telegram-desktop,ruscord`(Последний ставил из github) 
* Офис:`onlyoffice`
* Игрушки:`steam,prismlauncher,portproton,`
* Взять цвет с рабочего стола:`wl-color-picker`
* Обои:`swaybg`
* Графическое управление аудио:`pwvucontrol`
* Панелька снизу:`waybar`
* Программа для скриншотов:`hyprshot`
* Графический редактор:`krita`
* Заметки:`obsidian`
* Медиа проигрыватель:`vlc`
* Отображение часов в консоли:`tty-clock`
* Управление гтк темами:`nwg-look`
* аналог cd:`zoxide`
* Оболочка для консоли:`zsh`
* Тема для zsh:`oh-my-zsh`
* Также есть скрипт по подключению к wifi из консоли,расположенный по пути `config/waybar/scripts`
# Весь софт,который можно было настроить через конфиги,настроен
## Комбинации клавиш
 * `super + return`- терминал
 * `super + esc` - gotop
 * `super + d` - discord
 * `super + c` - neovim 
 * `super + x` - закрыть текущее окно
 * `super + w ` - zen 
 * `super + y ` - zen -e youtube.com 
 * `super + SHIFT + w` - перезапуск waybar     
 * `super + n` - nemo
 * `super + SHIFT + n` - nwg-look
 * `super + f` - fastfetch
 * `super + q` - выход из окружения
 * `super + e` - vifm
 * `super + s` - стим
 * `super + SHIFT + s` - убить стим
 * `super + p` - скриншот рабочего стола
 * `super + SHIFT + p` - скриншот выбранного окна 
 * `super + SHIFT + t` - tty-clock
 * `super + t` - телеграм
 * `super + m` - prismlauncher
 * `super + o` - onlyoffice
 * `super + SHIFT + o` - obsidian
 * `super + v` - vlc
 * `super + SHIFT + k` - krita
 * `super + SHIFT + x` - wlogout
 * `super + SHIFT + c` - wl-color-picker 
 * `super + g` - portproton
 * `Переключение между окнами в рабочем пространстве осуществляется по комбинации super + hjkl`
 * `Переключение между рабочими областями осущесвляется по комбинации super + 1-9`
 * `Перемещение окна на заданную рабочую область осуществляется по комбинации super +SHIFT + 1-9`
* `Управление громкостью осуществляется через XF86Audio`
# Снимки экрана
## Рабочий стол
![alt_image](./images/workbench.png)
## Кнопки питания 
![alt_image](./images/wlogout.png)
## fastfetch
![alt_image](./images/fastfetch.png)
## vifm
![alt_image](./images/vifm.png)
## wifi
![alt_image](./images/wifi.png)
## pwvucontrol
![alt_image](./images/pwvucontrol.png)
# На своей машине я подключил конфигурацию через ссылки ln -s,но вы можете подключать конфигурацию,как вам удобно
# так же использованны папки .themes и .icons для nwg-look
# Настоятельно рекомендую сохранить старую конфигурацию в другое место!
# Удачи!
