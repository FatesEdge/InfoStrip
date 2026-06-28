local InfoStrip = _G.InfoStrip

InfoStrip.Utils = {}
local Utils = InfoStrip.Utils

local TOKEN_ITEMS = {
    { key = "fps", displayKey = "showFPS", tokens = { "fps", "fps_value" }, defaultToken = "fps" },
    { key = "home", displayKey = "showHomeLatency", tokens = { "home", "home_value" }, defaultToken = "home" },
    { key = "world", displayKey = "showWorldLatency", tokens = { "world", "world_value" }, defaultToken = "world" },
    { key = "total", displayKey = "showTotalLatency", tokens = { "total", "total_value" }, defaultToken = "total" },
    { key = "bw_in", displayKey = "showBandwidthIn", tokens = { "bw_in", "bw_in_value" }, defaultToken = "bw_in" },
    { key = "bw_out", displayKey = "showBandwidthOut", tokens = { "bw_out", "bw_out_value" }, defaultToken = "bw_out" },
    { key = "speed", displayKey = "showSpeed", tokens = { "speed", "speed_value" }, defaultToken = "speed" },
    { key = "coord", displayKey = "showCoord", tokens = { "coord", "coord_value" }, defaultToken = "coord" },
    { key = "date", displayKey = "showDate", tokens = { "date", "date_value" }, defaultToken = "date" },
    { key = "local", displayKey = "showLocalTime", tokens = { "local", "local_time" }, defaultToken = "local" },
    { key = "server", displayKey = "showServerTime", tokens = { "server", "server_time" }, defaultToken = "server" },
}

local TOKEN_TO_ITEM = {}
for _, item in ipairs(TOKEN_ITEMS) do
    for _, token in ipairs(item.tokens) do
        TOKEN_TO_ITEM[token] = item
    end
end

local FONT_OPTIONS = {
    { value = "default", label = "Default", global = "STANDARD_TEXT_FONT" },
    { value = "friz", label = "Friz Quadrata TT", path = "Fonts\\FRIZQT__.TTF" },
    { value = "arialn", label = "Arial Narrow", path = "Fonts\\ARIALN.TTF" },
    { value = "morpheus", label = "Morpheus", path = "Fonts\\MORPHEUS.TTF" },
    { value = "skurri", label = "Skurri", path = "Fonts\\SKURRI.TTF" },
    { value = "arkai_t", label = "ARKai_T", path = "Fonts\\ARKai_T.TTF" },
    { value = "arkai_c", label = "ARKai_C", path = "Fonts\\ARKai_C.TTF" },
    { value = "blei", label = "bLEI00D", path = "Fonts\\bLEI00D.TTF" },
    { value = "bhei", label = "bHEI01B", path = "Fonts\\bHEI01B.TTF" },
}

function Utils.GetFontOptions()
    return FONT_OPTIONS
end

function Utils.ApplyDefaults(target, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            Utils.ApplyDefaults(target[key], value)
        elseif target[key] == nil then
            target[key] = value
        end
    end
end

function Utils.CopyColor(target, source)
    if not target or not source then
        return
    end

    target.r = source.r
    target.g = source.g
    target.b = source.b
    if source.a ~= nil then
        target.a = source.a
    end
end

function Utils.ColorToHex(color)
    color = color or { r = 1, g = 1, b = 1 }
    local r = math.floor(math.max(0, math.min(1, color.r or 1)) * 255 + 0.5)
    local g = math.floor(math.max(0, math.min(1, color.g or 1)) * 255 + 0.5)
    local b = math.floor(math.max(0, math.min(1, color.b or 1)) * 255 + 0.5)

    return string.format("%02x%02x%02x", r, g, b)
end

function Utils.ColorText(text, color)
    return "|cff" .. Utils.ColorToHex(color) .. tostring(text) .. "|r"
end

function Utils.MainColor()
    return InfoStripDB.appearance.text.mainColor
end

function Utils.GetValueColorConfig(kind)
    return InfoStripDB.appearance.valueColors[kind]
end

function Utils.GetThresholdColor(kind, value)
    local cfg = Utils.GetValueColorConfig(kind)
    local main = Utils.MainColor()

    if not cfg then
        return main
    end

    if cfg.mode == "followMain" then
        return main
    end

    if cfg.mode == "fixed" then
        return cfg.fixed
    end

    value = tonumber(value) or 0

    if cfg.thresholdDirection == "lowerIsWorse" then
        if value < (cfg.badBelow or 0) then
            return cfg.bad
        elseif value < (cfg.warningBelow or 0) then
            return cfg.warning
        end
        return cfg.good
    end

    if value >= (cfg.badAbove or 0) then
        return cfg.bad
    elseif value >= (cfg.warningAbove or 0) then
        return cfg.warning
    end

    return cfg.good
end

function Utils.GetSimpleValueColor(kind)
    local cfg = Utils.GetValueColorConfig(kind)
    if not cfg or cfg.mode == "followMain" then
        return Utils.MainColor()
    end
    return cfg.fixed or Utils.MainColor()
end

function Utils.GetFPSColor(fps)
    return Utils.GetThresholdColor("fps", fps)
end

function Utils.GetLatencyColor(ms, status)
    local cfg = Utils.GetValueColorConfig("latency")
    if status == "offline" then
        return cfg and cfg.bad or Utils.MainColor()
    elseif status == "stale" then
        return cfg and cfg.warning or Utils.MainColor()
    elseif status == "unknown" then
        return { r = 0.55, g = 0.55, b = 0.55 }
    end
    return Utils.GetThresholdColor("latency", ms)
end

function Utils.GetBandwidthColor(kbps)
    return Utils.GetThresholdColor("bandwidth", kbps)
end

function Utils.GetSpeedColor(percent)
    return Utils.GetThresholdColor("speed", percent or 0)
end

function Utils.GetCoordColor()
    return Utils.GetSimpleValueColor("coord")
end

function Utils.GetDateColor()
    return Utils.GetSimpleValueColor("date")
end

function Utils.GetTimeColor()
    return Utils.GetSimpleValueColor("time")
end

function Utils.FormatBandwidth(value)
    value = tonumber(value) or 0
    return string.format("%.1f", value)
end

function Utils.CleanDateFormat(format)
    format = tostring(format or "")
    format = format:gsub("^%s+", ""):gsub("%s+$", "")
    if format == "" then
        format = "%Y-%m-%d"
    end
    -- Keep this simple and safe: WoW/Lua date() accepts strftime-style tokens.
    -- Users can still use plain separators such as - / . spaces.
    return format
end

function Utils.GetFormatSettings()
    return InfoStripDB and InfoStripDB.appearance and InfoStripDB.appearance.format or {}
end

function Utils.GetTextAlign()
    local frame = InfoStripDB and InfoStripDB.appearance and InfoStripDB.appearance.frame or {}
    local align = frame.textAlign or "CENTER"
    if align ~= "LEFT" and align ~= "CENTER" and align ~= "RIGHT" then
        align = "CENTER"
    end
    return align
end

function Utils.FormatDate()
    local settings = Utils.GetFormatSettings()
    local format = Utils.CleanDateFormat(settings.dateFormat or "%Y-%m-%d")
    local ok, result = pcall(date, format)
    if ok and result and result ~= "" then
        return result
    end
    return date("%Y-%m-%d")
end

function Utils.FormatClock(hour, minute, second)
    hour = tonumber(hour) or 0
    minute = tonumber(minute) or 0
    second = tonumber(second) or 0

    local formatSettings = Utils.GetFormatSettings()
    local showSeconds = formatSettings.showSeconds and true or false
    local format = formatSettings.timeFormat or "24h"

    if format == "12h" then
        local suffix = hour >= 12 and "PM" or "AM"
        local displayHour = hour % 12
        if displayHour == 0 then displayHour = 12 end
        if showSeconds then
            return string.format("%d:%02d:%02d %s", displayHour, minute, second, suffix)
        end
        return string.format("%d:%02d %s", displayHour, minute, suffix)
    end

    if showSeconds then
        return string.format("%d:%02d:%02d", hour, minute, second)
    end
    return string.format("%d:%02d", hour, minute)
end

function Utils.FormatLocalTime()
    local now = date("*t")
    return Utils.FormatClock(now.hour, now.min, now.sec)
end

function Utils.FormatServerTime()
    -- Match WoW's native server-time clock.
    local now = date("*t")
    if GetGameTime then
        local hour, minute = GetGameTime()
        return Utils.FormatClock(hour or 0, minute or 0, now.sec)
    end

    return Utils.FormatClock(now.hour, now.min, now.sec)
end

function Utils.DecodeTemplateEscapes(text)
    text = text or ""
    text = text:gsub("\\n", "\n")
    text = text:gsub("\\t", "    ")
    text = text:gsub("\t", "    ")
    return text
end

function Utils.NormalizeTemplateFormat(template)
    template = tostring(template or "")
    template = template:gsub("\t", "    ")
    return template
end

function Utils.ParseTemplate(template)
    template = Utils.DecodeTemplateEscapes(template or "")

    local segments = {}
    local pos = 1

    while true do
        local startPos, endPos, token = template:find("{%%([%w_]+)}", pos)
        if not startPos then
            if pos <= #template then
                table.insert(segments, { kind = "text", value = template:sub(pos) })
            end
            break
        end

        if startPos > pos then
            table.insert(segments, { kind = "text", value = template:sub(pos, startPos - 1) })
        end

        if TOKEN_TO_ITEM[token] then
            table.insert(segments, { kind = "token", value = token })
        else
            table.insert(segments, { kind = "text", value = template:sub(startPos, endPos) })
        end

        pos = endPos + 1
    end

    return segments
end

function Utils.ScanTemplateDisplay(template)
    local state = {}
    for _, item in ipairs(TOKEN_ITEMS) do
        state[item.displayKey] = false
    end

    template = Utils.NormalizeTemplateFormat(template or "")
    for token in template:gmatch("{%%([%w_]+)}") do
        local item = TOKEN_TO_ITEM[token]
        if item then
            state[item.displayKey] = true
        end
    end

    return state
end

function Utils.SyncDisplayFromTemplate(template)
    if not InfoStripDB or not InfoStripDB.display then
        return
    end

    local state = Utils.ScanTemplateDisplay(template or InfoStripDB.general.template)
    for key, value in pairs(state) do
        InfoStripDB.display[key] = value
    end
end

function Utils.TemplateHasItemToken(template, item)
    template = template or ""
    for _, token in ipairs(item.tokens) do
        if template:find("{%" .. token .. "}", 1, true) then
            return true
        end
    end
    return false
end

function Utils.EnsureTemplateToken(displayKey)
    local item
    for _, candidate in ipairs(TOKEN_ITEMS) do
        if candidate.displayKey == displayKey then
            item = candidate
            break
        end
    end

    if not item then
        return
    end

    InfoStripDB.general.template = Utils.NormalizeTemplateFormat(InfoStripDB.general.template or "")

    if Utils.TemplateHasItemToken(InfoStripDB.general.template, item) then
        return
    end

    local template = InfoStripDB.general.template or ""
    if template ~= "" then
        template = template .. "  "
    end
    InfoStripDB.general.template = template .. "{%" .. item.defaultToken .. "}"
end

function Utils.RemoveTemplateTokens(displayKey)
    local template = Utils.NormalizeTemplateFormat(InfoStripDB.general.template or "")

    for _, item in ipairs(TOKEN_ITEMS) do
        if item.displayKey == displayKey then
            for _, token in ipairs(item.tokens) do
                template = template:gsub("%s*{%%" .. token .. "}%s*", " ")
            end
            break
        end
    end

    template = template:gsub("  +", " ")
    template = template:gsub("^%s+", "")
    template = template:gsub("%s+$", "")
    InfoStripDB.general.template = template
end

function Utils.SetDisplayItemEnabled(displayKey, enabled)
    InfoStripDB.display[displayKey] = enabled and true or false
    if enabled then
        Utils.EnsureTemplateToken(displayKey)
    else
        Utils.RemoveTemplateTokens(displayKey)
    end
end

function Utils.ClampNumber(value, minValue, maxValue, step)
    value = tonumber(value)
    if not value then
        return nil
    end

    if value < minValue then
        value = minValue
    elseif value > maxValue then
        value = maxValue
    end

    step = step or 1
    value = math.floor((value / step) + 0.5) * step
    return tonumber(string.format("%.2f", value))
end

function Utils.ValidateThresholdGroup(kind)
    local cfg = InfoStripDB.appearance.valueColors[kind]
    if not cfg or cfg.kind ~= "threshold" then
        return
    end

    if cfg.thresholdDirection == "lowerIsWorse" then
        cfg.warningBelow = tonumber(cfg.warningBelow) or 60
        cfg.badBelow = tonumber(cfg.badBelow) or 30
        if cfg.badBelow >= cfg.warningBelow then
            cfg.badBelow = cfg.warningBelow - 1
        end
    else
        cfg.warningAbove = tonumber(cfg.warningAbove) or 80
        cfg.badAbove = tonumber(cfg.badAbove) or 150
        if cfg.warningAbove >= cfg.badAbove then
            cfg.warningAbove = cfg.badAbove - 1
        end
    end
end

function Utils.ValidateAllThresholds()
    Utils.ValidateThresholdGroup("fps")
    Utils.ValidateThresholdGroup("latency")
    Utils.ValidateThresholdGroup("bandwidth")
    Utils.ValidateThresholdGroup("speed")
end

function Utils.ResetValueColor(kind)
    local current = InfoStripDB.appearance.valueColors[kind]
    local defaults = InfoStrip.defaults.appearance.valueColors[kind]
    if not current or not defaults then
        return
    end

    Utils.ApplyDefaults(current, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            Utils.CopyColor(current[key], value)
        else
            current[key] = value
        end
    end
end

function Utils.GetFontPath(value)
    value = value or "default"

    for _, option in ipairs(FONT_OPTIONS) do
        if option.value == value then
            if option.path and option.path ~= "" then
                return option.path
            end
            if option.global then
                local path = _G[option.global]
                if path and path ~= "" then
                    return path
                end
            end
        end
    end

    return STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
end

function Utils.NormalizeFontValue(value)
    value = value or "default"
    for _, option in ipairs(FONT_OPTIONS) do
        if option.value == value then
            return value
        end
    end
    return "default"
end

function Utils.GetOutlineFlag(value)
    if value == "OUTLINE" then
        return "OUTLINE"
    elseif value == "THICKOUTLINE" then
        return "THICKOUTLINE"
    end
    return ""
end

function Utils.GetPadding()
    local frame = InfoStripDB.appearance.frame
    if frame.paddingMode == "xy" then
        return frame.paddingX or 6, frame.paddingY or 4
    end

    local padding = frame.padding or 4
    return padding, padding
end

function Utils.FormatSpeed()
    local currentSpeed, runSpeed = GetUnitSpeed("player")
    currentSpeed = tonumber(currentSpeed) or 0
    runSpeed = tonumber(runSpeed) or 7
    if runSpeed <= 0 then
        runSpeed = 7
    end

    local formatSettings = Utils.GetFormatSettings()
    if formatSettings.speedFormat == "yards" then
        return string.format("%.1f", currentSpeed), "yd/s", currentSpeed
    end

    local percent = (currentSpeed / runSpeed) * 100
    return tostring(math.floor(percent + 0.5)), "%", percent
end

function Utils.GetPlayerCoordinates(useMockFallback)
    local cfg = InfoStripDB.coordinates

    if cfg.hideInCombat and UnitAffectingCombat and UnitAffectingCombat("player") then
        return nil
    end

    if cfg.hideInInstance and IsInInstance then
        local inInstance = IsInInstance()
        if inInstance then
            return nil
        end
    end

    if cfg.outdoorOnly and IsIndoors and IsIndoors() then
        return nil
    end

    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    if mapID and C_Map.GetPlayerMapPosition then
        local position = C_Map.GetPlayerMapPosition(mapID, "player")
        if position and position.GetXY then
            local x, y = position:GetXY()
            if x and y and x > 0 and y > 0 then
                local precision = tonumber(Utils.GetFormatSettings().coordPrecision) or 1
                local format = "%0." .. precision .. "f, %0." .. precision .. "f"
                return string.format(format, x * 100, y * 100)
            end
        end
    end

    if useMockFallback then
        return "52.4, 38.7"
    end

    if Utils.GetFormatSettings().coordUnavailableMode == "dash" then
        return "--"
    end

    return nil
end

function Utils.GetLabelIconSize()
    local fontSize = InfoStripDB and InfoStripDB.appearance and InfoStripDB.appearance.text and InfoStripDB.appearance.text.fontSize or 13
    fontSize = tonumber(fontSize) or 13
    if fontSize < 11 then fontSize = 11 end
    if fontSize > 24 then fontSize = 24 end
    return math.floor(fontSize + 2)
end

function Utils.IconText(kind)
    local iconSettings = InfoStripDB and InfoStripDB.general and InfoStripDB.general.icons
    if not iconSettings or iconSettings[kind] ~= true then
        return ""
    end

    local icons = {
        fps = "Interface\\Icons\\INV_Misc_PocketWatch_01",
        home = "Interface\\Icons\\INV_Misc_Map_01",
        world = "Interface\\Icons\\INV_Misc_Map_01",
        total = "Interface\\Icons\\INV_Misc_Spyglass_03",
        bw_in = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
        bw_out = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up",
        speed = "Interface\\Icons\\Ability_Rogue_Sprint",
        coord = "Interface\\Icons\\INV_Misc_Map_01",
        date = "Interface\\Icons\\INV_Misc_Note_01",
        localTime = "Interface\\Icons\\INV_Misc_PocketWatch_01",
        serverTime = "Interface\\Icons\\INV_Misc_PocketWatch_01",
    }

    local texture = icons[kind]
    if not texture then
        return ""
    end

    local size = Utils.GetLabelIconSize()
    return "|T" .. texture .. ":" .. size .. ":" .. size .. ":0:-3|t "
end
