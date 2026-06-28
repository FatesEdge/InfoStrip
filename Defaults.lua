local addonName = ...

_G.InfoStrip = _G.InfoStrip or {}
local InfoStrip = _G.InfoStrip

InfoStrip.addonName = addonName
InfoStrip.version = "1.0.0"
InfoStrip.authorName = "Fate's Edge"
InfoStrip.githubName = "FatesEdge"
InfoStrip.githubUrl = "https://github.com/FatesEdge/InfoStrip"

InfoStrip.defaults = {
    schemaVersion = "1.0.0",
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

    general = {
        updateIntervalMs = 1000,
        template = "{%fps}  {%home}  {%world}",
        showSettingsIcon = false,
        labels = {
            fps = true,
            home = true,
            world = true,
            total = true,
            bw_in = true,
            bw_out = true,
            speed = true,
            coord = true,
            region = true,
            date = true,
            localTime = true,
            serverTime = true,
        },

        icons = {
            fps = false,
            home = false,
            world = false,
            total = false,
            bw_in = false,
            bw_out = false,
            speed = false,
            coord = false,
            region = true,
            date = false,
            localTime = false,
            serverTime = false,
        },
    },

    display = {
        showFPS = true,
        showHomeLatency = true,
        showWorldLatency = true,
        showTotalLatency = false,
        showBandwidthIn = false,
        showBandwidthOut = false,
        showSpeed = false,
        showCoord = false,
        showRegion = false,
        showDate = false,
        showLocalTime = false,
        showServerTime = false,
    },

    appearance = {
        text = {
            mainColor = { r = 1.0, g = 0.82, b = 0.0 },
            fontFamily = "default",
            fontSize = 14,
            outline = "NONE",
            bold = false,
            shadow = true,
            shadowAlpha = 0.8,
            shadowOffsetX = 1,
            shadowOffsetY = -1,
        },

        frame = {
            backgroundEnabled = false,
            backgroundColor = { r = 0.0, g = 0.0, b = 0.0, a = 0.35 },
            borderEnabled = false,
            borderColor = { r = 1.0, g = 1.0, b = 1.0, a = 0.25 },
            borderSize = 1,
            cornerRadius = 6,
            paddingMode = "uniform",
            padding = 4,
            paddingX = 6,
            paddingY = 4,
            lineSpacingMultiplier = 1.2,
            textAlign = "LEFT",
        },

        format = {
            dateFormat = "%Y-%m-%d",
            timeFormat = "24h",
            showSeconds = false,
            speedFormat = "percent",
            coordUnavailableMode = "hide",
            coordPrecision = 2,
        },

        valueColors = {
            fps = {
                kind = "threshold",
                thresholdDirection = "lowerIsWorse",
                mode = "thresholdCustom",
                fixed = { r = 0.0, g = 1.0, b = 0.0 },
                good = { r = 0.0, g = 1.0, b = 0.0 },
                warning = { r = 1.0, g = 1.0, b = 0.0 },
                bad = { r = 1.0, g = 0.0, b = 0.0 },
                warningBelow = 60,
                badBelow = 30,
            },

            latency = {
                kind = "threshold",
                thresholdDirection = "higherIsWorse",
                mode = "thresholdCustom",
                fixed = { r = 0.0, g = 1.0, b = 0.0 },
                good = { r = 0.0, g = 1.0, b = 0.0 },
                warning = { r = 1.0, g = 1.0, b = 0.0 },
                bad = { r = 1.0, g = 0.0, b = 0.0 },
                warningAbove = 80,
                badAbove = 150,
            },

            bandwidth = {
                kind = "threshold",
                thresholdDirection = "higherIsWorse",
                mode = "followMain",
                fixed = { r = 0.0, g = 0.75, b = 1.0 },
                good = { r = 0.0, g = 0.75, b = 1.0 },
                warning = { r = 1.0, g = 1.0, b = 0.0 },
                bad = { r = 1.0, g = 0.0, b = 0.0 },
                warningAbove = 128,
                badAbove = 512,
            },

            speed = {
                kind = "threshold",
                thresholdDirection = "lowerIsWorse",
                mode = "followMain",
                fixed = { r = 1.0, g = 1.0, b = 1.0 },
                good = { r = 0.0, g = 1.0, b = 0.0 },
                warning = { r = 1.0, g = 1.0, b = 0.0 },
                bad = { r = 1.0, g = 0.0, b = 0.0 },
                warningBelow = 100,
                badBelow = 50,
            },

            coord = {
                kind = "simple",
                mode = "followMain",
                fixed = { r = 1.0, g = 1.0, b = 1.0 },
            },

            region = {
                kind = "simple",
                mode = "followMain",
                fixed = { r = 1.0, g = 1.0, b = 1.0 },
            },

            date = {
                kind = "simple",
                mode = "followMain",
                fixed = { r = 1.0, g = 1.0, b = 1.0 },
            },

            time = {
                kind = "simple",
                mode = "followMain",
                fixed = { r = 1.0, g = 1.0, b = 1.0 },
            },
        },
    },


    coordinates = {
        outdoorOnly = true,
        hideInCombat = true,
        hideInInstance = true,
    },

    network = {
        staleAfterMs = 5000,
        showOffline = true,
        showStale = true,
    },

    ui = {
        appearanceExpanded = {
            fps = true,
            latency = true,
            bandwidth = false,
            speed = false,
            coord = false,
            date = false,
            time = false,
            region = false,
        },
    },
}
