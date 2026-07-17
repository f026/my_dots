local vars = {}
--Программы
vars.TERMINAL = "alacritty"
vars.EXPLORER = vars.TERMINAL.. " --class=filemanager -e yazi"
vars.EDITOR = vars.TERMINAL.. " --class=editor -e nvim"
vars.FASTFETCH = vars.TERMINAL.. " --class=ff -e sh -c 'fastfetch; exec zsh'"
vars.TOP = vars.TERMINAL.. " --class=btop -e btop"
vars.ZAPRET = vars.TERMINAL.. " --class=zapret -e zapret"
vars.BROWSER = "zen-browser"
vars.SWITCHER = "snappy-switcher next"
vars.YOUTUBE = vars.BROWSER.. " youtube.com"
vars.COLORPICKER = "wl-color-picker"
vars.RUSCORD = "flatpak run net.russcord.app"
vars.DISCORD = vars.BROWSER.. " discord.com/app"
vars.SOUNDPAD = "pwsp-gui"
vars.EXIT = "killall Hyprland"
vars.ROBLOX = "flatpak run org.vinegarhq.Sober"
--Мониторы
vars.MAIN_MONITOR = "HDMI-A-1"
vars.SECOND_MONITOR = "eDP-1"

return vars
