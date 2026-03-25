-- ФОРС 192 кГц для ВСЕХ выводов
local force_192k_rule = {
  matches = {
    {
      { "node.name", "matches", "alsa_output.*" },
    },
  },
  apply_properties = {
    ["audio.rate"]            = 192000,
    ["audio.allowed-rates"]   = "192000",         -- ТОЛЬКО 192кГц
    ["audio.format"]          = "S32LE",
    ["api.alsa.period-size"]  = 1024,
    ["api.alsa.headroom"]     = 2048,
    ["resample.quality"]      = 8,
  },
}

-- VoIP всё равно будет ресемплиться, но ВЫХОД на 192кГц
-- VoIP: FORCE 48 kHz на ВХОДЕ приложения, но выход всё равно 192 kHz
local voip_input_rule = {
  matches = {
    {
      { "media.role", "=", "communication" },
      { "media.class", "=", "Stream/Input/Audio" },  -- ЗАХВАТ (микрофон → Discord)
    },
  },
  apply_properties = {
    ["audio.rate"]            = 48000,              -- Discord хочет 48k
    ["audio.format"]          = "S16LE",            -- Discord хочет 16-bit
    ["node.latency"]          = "256/48000",        -- 5.33ms (норм для VoIP)
    ["api.alsa.period-size"]  = 256,
    ["resample.quality"]      = 4,                  -- Экономим CPU
  },
}

-- VoIP: PLAYBACK (Discord → твои колонки)
local voip_output_rule = {
  matches = {
    {
      { "media.role", "=", "communication" },
      { "media.class", "=", "Stream/Output/Audio" }, -- ВОСПРОИЗВЕДЕНИЕ
    },
  },
  apply_properties = {
    ["audio.rate"]            = 48000,              -- Discord отдаёт 48k
    ["audio.format"]          = "S16LE",
    ["node.latency"]          = "512/48000",        -- 10.67ms (больше = стабильнее)
    ["api.alsa.period-size"]  = 512,
    ["resample.quality"]      = 4,
  },
}

table.insert(alsa_monitor.rules, voip_input_rule)
table.insert(alsa_monitor.rules, voip_output_rule)
table.insert(alsa_monitor.rules, force_192k_rule)
