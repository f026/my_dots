local vars = {}
--Программы
vars.TERMINAL = "kitty"
vars.EXPLORER = vars.TERMINAL.. " --class=filemanager -e yazi"
vars.EDITOR = vars.TERMINAL.. " --class=editor -e nvim"
vars.FASTFETCH = vars.TERMINAL.. " --class=ff -e sh -c 'fastfetch; exec bash'"
vars.TOP = vars.TERMINAL.. " --class=btop -e btop"
vars.BROWSER = "zen-browser"
vars.SWITCHER = "snappy-switcher toggle && sleep 2 && snappy-switcher next "
vars.YOUTUBE = vars.BROWSER.. " youtube.com"
vars.COLORPICKER = "wl-color-picker"
vars.DISCORD = "discord"
vars.SOUNDPAD = "pwsp-gui"
vars.EXIT = "killall Hyprland"
vars.SIZE_WINDOW = "840 560"
--Мониторы
vars.MAIN_MONITOR = "HDMI-A-1"
vars.SECOND_MONITOR = "eDP-1"
return vars
