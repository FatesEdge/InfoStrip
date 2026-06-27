local InfoStrip = _G.InfoStrip
local Utils = InfoStrip.Utils

InfoStrip.Display = {}

local Display = InfoStrip.Display

function Display:CreateFrame()
    if self.frame then
        return
    end

    local frame = CreateFrame("Frame", "InfoStripFrame", UIParent, "BackdropTemplate")
    frame:SetSize(620, 32)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetClampedToScreen(true)

    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        tileSize = 0,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.text:SetPoint("CENTER")
    frame.text:SetJustifyH("CENTER")
    frame.text:SetJustifyV("MIDDLE")
    frame.text:SetText("InfoStrip")

    frame:SetScript("OnDragStart", function(self)
        if not InfoStripDB.position.locked then
            self:StartMoving()
        end
    end)

    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Display:SavePosition()
    end)

    frame:SetScript("OnUpdate", function(_, elapsed)
        Display:OnUpdate(elapsed)
    end)

    self.frame = frame
end

function Display:ApplySettings()
    if not self.frame then
        return
    end

    local pos = InfoStripDB.position

    self.frame:ClearAllPoints()
    self.frame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
    self.frame:SetScale(pos.scale or 1)
    self.frame:SetAlpha(pos.alpha or 1)

    if InfoStripDB.enabled then
        self.frame:Show()
    else
        self.frame:Hide()
    end

    if pos.locked then
        self.frame:SetBackdropColor(0, 0, 0, 0)
        self.frame:SetBackdropBorderColor(0, 0, 0, 0)
    else
        self.frame:SetBackdropColor(0, 0, 0, 0.35)
        self.frame:SetBackdropBorderColor(1, 1, 1, 0.4)
    end

    self:UpdateText()
end

function Display:SavePosition()
    if not self.frame then
        return
    end

    local point, _, relativePoint, x, y = self.frame:GetPoint()
    InfoStripDB.position.point = point
    InfoStripDB.position.relativePoint = relativePoint
    InfoStripDB.position.x = x
    InfoStripDB.position.y = y
end

function Display:ResetPosition()
    InfoStripDB.position.point = InfoStrip.defaults.position.point
    InfoStripDB.position.relativePoint = InfoStrip.defaults.position.relativePoint
    InfoStripDB.position.x = InfoStrip.defaults.position.x
    InfoStripDB.position.y = InfoStrip.defaults.position.y
    self:ApplySettings()
end

function Display:BuildData()
    local fps = math.floor(GetFramerate() + 0.5)
    local _, _, homeLatency, worldLatency = GetNetStats()

    return {
        fps = fps,
        homeLatency = homeLatency,
        worldLatency = worldLatency,
        localTime = date("%H:%M"),
        serverTime = Utils.FormatServerTime(),
    }
end

function Display:TokenText(token, data)
    local main = InfoStripDB.colors.main

    if token == "fps" then
        if not InfoStripDB.display.showFPS then return "" end
        return Utils.ColorText(InfoStrip:L("fps") .. " ", main)
            .. Utils.ColorText(data.fps, Utils.GetFPSColor(data.fps))
    end

    if token == "fps_value" then
        if not InfoStripDB.display.showFPS then return "" end
        return Utils.ColorText(data.fps, Utils.GetFPSColor(data.fps))
    end

    if token == "home" then
        if not InfoStripDB.display.showHomeLatency then return "" end
        return Utils.ColorText(InfoStrip:L("home") .. " ", main)
            .. Utils.ColorText(data.homeLatency, Utils.GetLatencyColor(data.homeLatency))
            .. Utils.ColorText("ms", main)
    end

    if token == "home_value" then
        if not InfoStripDB.display.showHomeLatency then return "" end
        return Utils.ColorText(data.homeLatency, Utils.GetLatencyColor(data.homeLatency))
    end

    if token == "world" then
        if not InfoStripDB.display.showWorldLatency then return "" end
        return Utils.ColorText(InfoStrip:L("world") .. " ", main)
            .. Utils.ColorText(data.worldLatency, Utils.GetLatencyColor(data.worldLatency))
            .. Utils.ColorText("ms", main)
    end

    if token == "world_value" then
        if not InfoStripDB.display.showWorldLatency then return "" end
        return Utils.ColorText(data.worldLatency, Utils.GetLatencyColor(data.worldLatency))
    end

    if token == "local" then
        if not InfoStripDB.display.showLocalTime then return "" end
        return Utils.ColorText(InfoStrip:L("localTime") .. " " .. data.localTime, main)
    end

    if token == "local_time" then
        if not InfoStripDB.display.showLocalTime then return "" end
        return Utils.ColorText(data.localTime, main)
    end

    if token == "server" then
        if not InfoStripDB.display.showServerTime then return "" end
        return Utils.ColorText(InfoStrip:L("serverTime") .. " " .. data.serverTime, main)
    end

    if token == "server_time" then
        if not InfoStripDB.display.showServerTime then return "" end
        return Utils.ColorText(data.serverTime, main)
    end

    return "{" .. token .. "}"
end

function Display:BuildText()
    local data = self:BuildData()
    local template = Utils.DecodeTemplateEscapes(InfoStripDB.general.template)

    local text = template:gsub("{([%w_]+)}", function(token)
        return Display:TokenText(token, data)
    end)

    text = text:gsub(" +", " ")
    text = text:gsub("^%s+", "")
    text = text:gsub("%s+$", "")

    if text == "" then
        text = Utils.ColorText("InfoStrip", InfoStripDB.colors.main)
    end

    return text
end

function Display:UpdateText()
    if not self.frame or not self.frame.text then
        return
    end

    self.frame.text:SetText(self:BuildText())
end

function Display:OnUpdate(elapsed)
    if not InfoStripDB or not InfoStripDB.enabled then
        return
    end

    self.elapsed = (self.elapsed or 0) + elapsed

    if self.elapsed < InfoStripDB.general.updateInterval then
        return
    end

    self.elapsed = 0
    self:UpdateText()
end

function Display:Initialize()
    self:CreateFrame()
    self:ApplySettings()
end
