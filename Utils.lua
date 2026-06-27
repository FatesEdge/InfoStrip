local InfoStrip = _G.InfoStrip

InfoStrip.Utils = {}

function InfoStrip.Utils.ApplyDefaults(target, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            InfoStrip.Utils.ApplyDefaults(target[key], value)
        elseif target[key] == nil then
            target[key] = value
        end
    end
end

function InfoStrip.Utils.ColorToHex(color)
    local r = math.floor((color.r or 1) * 255 + 0.5)
    local g = math.floor((color.g or 1) * 255 + 0.5)
    local b = math.floor((color.b or 1) * 255 + 0.5)

    return string.format("%02x%02x%02x", r, g, b)
end

function InfoStrip.Utils.ColorText(text, color)
    return "|cff" .. InfoStrip.Utils.ColorToHex(color) .. tostring(text) .. "|r"
end

function InfoStrip.Utils.GetFPSColor(fps)
    local cfg = InfoStripDB.colors.fps

    if cfg.mode == "followMain" then
        return InfoStripDB.colors.main
    end

    if cfg.mode == "fixed" then
        return cfg.fixed
    end

    if fps < cfg.badBelow then
        return cfg.bad
    elseif fps < cfg.warningBelow then
        return cfg.warning
    else
        return cfg.good
    end
end

function InfoStrip.Utils.GetLatencyColor(ms)
    local cfg = InfoStripDB.colors.latency

    if cfg.mode == "followMain" then
        return InfoStripDB.colors.main
    end

    if cfg.mode == "fixed" then
        return cfg.fixed
    end

    if ms >= cfg.badAbove then
        return cfg.bad
    elseif ms >= cfg.warningAbove then
        return cfg.warning
    else
        return cfg.good
    end
end

function InfoStrip.Utils.DecodeTemplateEscapes(text)
    text = text or ""
    text = text:gsub("\\n", "\n")
    text = text:gsub("\\t", "\t")
    return text
end

function InfoStrip.Utils.FormatServerTime()
    local hour, minute = GetGameTime()
    return string.format("%02d:%02d", hour, minute)
end
