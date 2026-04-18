<p>Hi! Это мои доты hyprland</p>

## Информация о репозитории
``
Данное рабочее окружение было построенно вокруг оконного менеджера hyprland на дистрибутиве Archlinux.
Репозиторий включает в себя не только конфиги hyprland,но и терминала,консольного текстового редактора,syshud,pipewire,waybar и fastfetch
Рабочее окружение расчитанно на два монитора.
``
## Основной софт и скрипты
* wm:`Hyprland`
* Терминал:`foot`
* Меню выхода:`wlogout`(Ставил из AUR)
* Экран блокировки:`hyprlock`
* Консольный текстовый редактор:`neovim`
* Консольный мониторинг процессов:`gotop`
* Консольный  файловый менеджер:`yazi`
* Обычный файловый менеджер:`nemo`(для браузера)
* Графическая программа для аудио:`wiremix`(Ставил из AUR)
* Браузер:`zen`
* Мессенжеры:`telegram-desktop,discord` 
* Офис:`onlyoffice`
* Игрушки:`steam,prismlauncher,portproton`
* Взять цвет с рабочего стола:`wl-color-picker`
* Обои:`swaybg`
* Управление аудио:`wiremix`
* Панелька снизу:`waybar`
* Программа для скриншотов:`hyprshot`
* Графический редактор:`krita`
* Заметки:`obsidian`
* Медиа проигрыватель:`vlc`
* Отображение часов в консоли:`tty-clock`
* Управление гтк темами:`nwg-look`
* аналог cd:`zoxide`
* Прога для визуального переключения рабочих пространств:`snappy-switcher`(Ставил из AUR)
* Popup громкости: `syshud`
* Оболочка для консоли:`zsh`
* Тема для zsh:`oh-my-zsh`
* Аналог ls: `lsd`
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
 * `super + e` - yazi
 * `super + s` - стим
 * `super + SHIFT + s` - убить стим
 * `super + p` - скриншот рабочего стола
 * `super + SHIFT + p` - скриншот выбранного окна 
 * `super + SHIFT + t` - tty-clock
 * `super+m`:prismlauncher
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
* `Переключение между окнами осуществляется при помощи alt+tab`
# Снимки экрана
## Рабочий стол
![alt_image](./images/workbench.png)
## Кнопки питания 
![alt_image](./images/wlogout.png)
## fastfetch
![alt_image](./images/fastfetch.png)
## yazi 
![alt_image](./images/yazi.png)
# Обои для системы нашел [Тут](https://github.com/AngelJumbo/gruvbox-wallpapers/tree/main/wallpapers%2Fminimalistic)
# На своей машине я подключил конфигурацию через ссылки ln -sf,но вы можете подключать конфигурацию,как вам удобно
# так же использованны папки .themes и .icons для nwg-look
# Настоятельно рекомендую сохранить старую конфигурацию в другое место!
# Удачи!
