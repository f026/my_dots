local M = require("modules.declorations")
hl.monitor({
    output = M.MAIN_MONITOR,
    mode = "1920x1080@144",
    position = "0x0",
    scale = 1
})
hl.monitor({
    output = M.SECOND_MONITOR,
    mode = "1920x1080@60",
    position = "1920x0",
    scale = 1.5;
})

