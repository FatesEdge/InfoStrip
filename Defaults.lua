local addonName = ...

_G.InfoStrip = _G.InfoStrip or {}
local InfoStrip = _G.InfoStrip

InfoStrip.addonName = addonName
InfoStrip.version = "0.2.1"

InfoStrip.defaults = {
    enabled = true,

    language = "auto",

    position = {
        point = "CENTER",
        relativePoint = "CENTER",
        x = 0,
        y = 220,
        locked = false,
        scale = 1.0,
        alpha = 1.0,
    },

    display = {
        showFPS = true,
        showHomeLatency = true,
        showWorldLatency = true,
        showLocalTime = true,
        showServerTime = true,
    },

    general = {
        updateInterval = 1.0,
        template = "{fps}  {home}  {world}  {local}  {server}",
    },

    colors = {
        main = { r = 1.0, g = 1.0, b = 1.0 },

        fps = {
            mode = "thresholdDefault",
            fixed = { r = 0.0, g = 1.0, b = 0.0 },
            good = { r = 0.0, g = 1.0, b = 0.0 },
            warning = { r = 1.0, g = 1.0, b = 0.0 },
            bad = { r = 1.0, g = 0.0, b = 0.0 },
            warningBelow = 60,
            badBelow = 30,
        },

        latency = {
            mode = "thresholdDefault",
            fixed = { r = 0.0, g = 1.0, b = 0.0 },
            good = { r = 0.0, g = 1.0, b = 0.0 },
            warning = { r = 1.0, g = 1.0, b = 0.0 },
            bad = { r = 1.0, g = 0.0, b = 0.0 },
            warningAbove = 80,
            badAbove = 150,
        },
    },
}
