local InfoStrip = _G.InfoStrip
local Utils = InfoStrip.Utils

InfoStrip.Display = {}
local Display = InfoStrip.Display

local labelIconKinds = {
    localTime = "localTime",
    serverTime = "serverTime",
}

local function ShowFieldLabel(kind)
    local labels = InfoStripDB and InfoStripDB.general and InfoStripDB.general.labels
    if not labels then
        return true
    end
    return labels[kind] ~= false
end

local function AddLabel(kind, label)
    if not ShowFieldLabel(kind) then
        return ""
    end

    return Utils.ColorText(Utils.IconText(labelIconKinds[kind] or kind) .. label .. " ", Utils.MainColor())
end

local function AddUnit(unit)
    return Utils.ColorText(unit, Utils.MainColor())
end

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
    frame.text:SetJustifyH("CENTER")
    frame.text:SetJustifyV("MIDDLE")
    if frame.text.SetWordWrap then frame.text:SetWordWrap(false) end
    if frame.text.SetNonSpaceWrap then frame.text:SetNonSpaceWrap(false) end
    frame.text:SetText("InfoStrip")
    frame.lines = { frame.text }

    frame:SetScript("OnDragStart", function(self)
        if not InfoStripDB.position.locked then
            self:StartMoving()
        end
    end)

    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        Display:SavePosition()
    end)

    frame:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton"
            and InfoStripDB
            and InfoStripDB.general
            and InfoStripDB.general.rightClickOpenOptions
            and InfoStrip.Options then
            InfoStrip.Options:Open()
        end
    end)

    frame:SetScript("OnUpdate", function(_, elapsed)
        Display:OnUpdate(elapsed)
    end)

    self.frame = frame
end

function Display:InvalidateRenderCache()
    self.lastDisplayText = nil
    self.lastPadX = nil
    self.lastPadY = nil
    self.lastTextAlign = nil
end

function Display:QueueDeferredUpdate()
    if not C_Timer or not C_Timer.After then
        return
    end

    self.deferredUpdateTicket = (self.deferredUpdateTicket or 0) + 1
    local ticket = self.deferredUpdateTicket

    local function repaint()
        if not InfoStrip.Display or InfoStrip.Display.deferredUpdateTicket ~= ticket then
            return
        end
        InfoStrip.Display:InvalidateRenderCache()
        InfoStrip.Display:UpdateText()
    end

    C_Timer.After(0, repaint)
    C_Timer.After(0.05, repaint)
end

local function SplitDisplayLines(text)
    text = tostring(text or "")
    local lines = {}
    local startPos = 1

    while true do
        local lineEnd = text:find("\n", startPos, true)
        if not lineEnd then
            table.insert(lines, text:sub(startPos))
            break
        end

        table.insert(lines, text:sub(startPos, lineEnd - 1))
        startPos = lineEnd + 1
    end

    if #lines == 0 then
        lines[1] = ""
    end

    return lines
end

function Display:ApplyTextStyleToFontString(fontString)
    if not fontString or not InfoStripDB or not InfoStripDB.appearance then
        return
    end

    local textSettings = InfoStripDB.appearance.text
    local fontPath = Utils.GetFontPath(textSettings.fontFamily)
    local fontSize = tonumber(textSettings.fontSize) or 13
    local outline = Utils.GetOutlineFlag(textSettings.outline)

    if textSettings.bold then
        if outline == "" then
            outline = "OUTLINE"
        elseif outline == "OUTLINE" then
            outline = "THICKOUTLINE"
        end
    end

    local fontOK = fontString:SetFont(fontPath, fontSize, outline)
    if fontOK == false then
        fontString:SetFont(STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF", fontSize, outline)
    end

    fontString:SetJustifyH(Utils.GetTextAlign())
    fontString:SetJustifyV("MIDDLE")
    if fontString.SetWordWrap then fontString:SetWordWrap(false) end
    if fontString.SetNonSpaceWrap then fontString:SetNonSpaceWrap(false) end

    if textSettings.shadow then
        local shadowX = tonumber(textSettings.shadowOffsetX) or 1
        local shadowY = tonumber(textSettings.shadowOffsetY) or -1
        fontString:SetShadowOffset(shadowX, shadowY)
        fontString:SetShadowColor(0, 0, 0, textSettings.shadowAlpha or 0.8)
    else
        fontString:SetShadowOffset(0, 0)
        fontString:SetShadowColor(0, 0, 0, 0)
    end
end

function Display:GetLineFontString(index)
    if not self.frame then
        return nil
    end

    self.frame.lines = self.frame.lines or { self.frame.text }
    local line = self.frame.lines[index]

    if not line then
        line = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        self.frame.lines[index] = line
        self:ApplyTextStyleToFontString(line)
    end

    return line
end

function Display:ApplyTextStyle()
    if not self.frame or not self.frame.text then
        return
    end

    self.frame.lines = self.frame.lines or { self.frame.text }
    for _, line in ipairs(self.frame.lines) do
        self:ApplyTextStyleToFontString(line)
    end

    self:InvalidateRenderCache()
end

function Display:ApplyFrameStyle()
    if not self.frame then
        return
    end

    local frameSettings = InfoStripDB.appearance.frame
    local borderSize = tonumber(frameSettings.borderSize) or 1
    if borderSize < 1 then borderSize = 1 end
    if borderSize > 6 then borderSize = 6 end

    local cornerRadius = tonumber(frameSettings.cornerRadius) or 0
    if cornerRadius < 0 then cornerRadius = 0 end
    if cornerRadius > 18 then cornerRadius = 18 end

    local useRoundedBackdrop = cornerRadius > 0
    local backdrop = {
        bgFile = useRoundedBackdrop and "Interface\\Tooltips\\UI-Tooltip-Background" or "Interface\\Buttons\\WHITE8x8",
        tile = false,
        tileSize = 0,
        insets = useRoundedBackdrop and { left = 4, right = 4, top = 4, bottom = 4 } or { left = 0, right = 0, top = 0, bottom = 0 },
    }

    if useRoundedBackdrop then
        backdrop.edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border"
        backdrop.edgeSize = math.max(8, cornerRadius + borderSize)
    elseif frameSettings.borderEnabled then
        backdrop.edgeFile = "Interface\\Buttons\\WHITE8x8"
        backdrop.edgeSize = borderSize
    else
        backdrop.edgeFile = nil
        backdrop.edgeSize = 0
    end

    self.frame:SetBackdrop(backdrop)

    if frameSettings.backgroundEnabled then
        local c = frameSettings.backgroundColor
        self.frame:SetBackdropColor(c.r or 0, c.g or 0, c.b or 0, c.a or 0.35)
    else
        self.frame:SetBackdropColor(0, 0, 0, 0)
    end

    if frameSettings.borderEnabled then
        local c = frameSettings.borderColor
        self.frame:SetBackdropBorderColor(c.r or 1, c.g or 1, c.b or 1, c.a or 0.25)
    elseif useRoundedBackdrop and frameSettings.backgroundEnabled then
        local c = frameSettings.backgroundColor
        self.frame:SetBackdropBorderColor(c.r or 0, c.g or 0, c.b or 0, c.a or 0.35)
    else
        self.frame:SetBackdropBorderColor(0, 0, 0, 0)
    end

    self:InvalidateRenderCache()
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

    self:ApplyTextStyle()
    self:ApplyFrameStyle()
    self:UpdateMinimapButton()
    self:UpdateText()
    self:QueueDeferredUpdate()
end

function Display:SavePosition()
    if not self.frame or not InfoStripDB or not InfoStripDB.position then
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

function Display:GetNetworkState(homeLatency, worldLatency, bandwidthIn, bandwidthOut)
    if UnitIsConnected and not UnitIsConnected("player") then
        return "offline"
    end

    if not homeLatency or not worldLatency then
        return "unknown"
    end

    local now = GetTime and GetTime() or 0
    local sample = table.concat({
        tostring(homeLatency or ""),
        tostring(worldLatency or ""),
        string.format("%.1f", tonumber(bandwidthIn) or 0),
        string.format("%.1f", tonumber(bandwidthOut) or 0),
    }, ":")

    if self.lastNetworkSample ~= sample then
        self.lastNetworkSample = sample
        self.lastNetworkChangeTime = now
        return "normal"
    end

    local staleAfter = (InfoStripDB.network.staleAfterMs or 5000) / 1000
    local unchangedFor = now - (self.lastNetworkChangeTime or now)

    if InfoStripDB.network.showStale and unchangedFor >= staleAfter and (tonumber(bandwidthIn) or 0) == 0 and (tonumber(bandwidthOut) or 0) == 0 then
        return "stale"
    end

    return "normal"
end

local function MarkTokenNeed(needs, token)
    if token == "fps" or token == "fps_value" then
        if InfoStripDB.display.showFPS then needs.fps = true end
    elseif token == "home" or token == "home_value" then
        if InfoStripDB.display.showHomeLatency then needs.network = true; needs.homeLatency = true end
    elseif token == "world" or token == "world_value" then
        if InfoStripDB.display.showWorldLatency then needs.network = true; needs.worldLatency = true end
    elseif token == "total" or token == "total_value" then
        if InfoStripDB.display.showTotalLatency then needs.network = true; needs.totalLatency = true end
    elseif token == "bw_in" or token == "bw_in_value" then
        if InfoStripDB.display.showBandwidthIn then needs.network = true; needs.bandwidthIn = true end
    elseif token == "bw_out" or token == "bw_out_value" then
        if InfoStripDB.display.showBandwidthOut then needs.network = true; needs.bandwidthOut = true end
    elseif token == "speed" or token == "speed_value" then
        if InfoStripDB.display.showSpeed then needs.speed = true end
    elseif token == "coord" or token == "coord_value" then
        if InfoStripDB.display.showCoord then needs.coord = true end
    elseif token == "region" or token == "region_value" then
        if InfoStripDB.display.showRegion then needs.region = true end
    elseif token == "date" or token == "date_value" then
        if InfoStripDB.display.showDate then needs.date = true end
    elseif token == "local" or token == "local_time" then
        if InfoStripDB.display.showLocalTime then needs.localTime = true end
    elseif token == "server" or token == "server_time" then
        if InfoStripDB.display.showServerTime then needs.serverTime = true end
    end
end

function Display:GetDataNeeds(segments)
    local needs = {}
    for _, segment in ipairs(segments or {}) do
        if segment.kind == "token" then
            MarkTokenNeed(needs, segment.value)
        end
    end
    return needs
end

function Display:BuildData(usePreviewFallback, segments)
    local needs = self:GetDataNeeds(segments)
    local data = {}

    if needs.fps then
        data.fps = math.floor((GetFramerate and GetFramerate() or 0) + 0.5)
    end

    if needs.network then
        local bandwidthIn, bandwidthOut, homeLatency, worldLatency = GetNetStats()
        data.bandwidthIn = bandwidthIn or 0
        data.bandwidthOut = bandwidthOut or 0
        data.homeLatency = homeLatency
        data.worldLatency = worldLatency
        data.totalLatency = (tonumber(homeLatency) or 0) + (tonumber(worldLatency) or 0)
        data.networkState = self:GetNetworkState(homeLatency, worldLatency, data.bandwidthIn, data.bandwidthOut)
    else
        data.networkState = "normal"
    end

    if needs.speed then
        data.speedValue, data.speedUnit, data.speedPercent = Utils.FormatSpeed()
    end

    if needs.coord then
        data.coord = Utils.GetPlayerCoordinates(usePreviewFallback)
    end

    if needs.region then
        data.region = Utils.GetRegionCode(usePreviewFallback)
    end

    if needs.date then
        data.dateText = Utils.FormatDate()
    end

    if needs.localTime then
        data.localTime = Utils.FormatLocalTime()
    end

    if needs.serverTime then
        data.serverTime = Utils.FormatServerTime()
    end

    return data
end

function Display:LatencyText(labelKey, value, data, fullToken)
    local status = data.networkState

    if status == "offline" and InfoStripDB.network.showOffline then
        if fullToken then
            return AddLabel(labelKey, InfoStrip:L(labelKey)) .. Utils.ColorText(InfoStrip:L("offline"), Utils.GetLatencyColor(value, status))
        end
        return Utils.ColorText(InfoStrip:L("offline"), Utils.GetLatencyColor(value, status))
    elseif status == "stale" and InfoStripDB.network.showStale then
        if fullToken then
            return AddLabel(labelKey, InfoStrip:L(labelKey)) .. Utils.ColorText(InfoStrip:L("stale"), Utils.GetLatencyColor(value, status))
        end
        return Utils.ColorText(InfoStrip:L("stale"), Utils.GetLatencyColor(value, status))
    elseif status == "unknown" then
        if fullToken then
            return AddLabel(labelKey, InfoStrip:L(labelKey)) .. Utils.ColorText(InfoStrip:L("unknown"), Utils.GetLatencyColor(value, status))
        end
        return Utils.ColorText(InfoStrip:L("unknown"), Utils.GetLatencyColor(value, status))
    end

    value = tonumber(value) or 0
    if fullToken then
        return AddLabel(labelKey, InfoStrip:L(labelKey))
            .. Utils.ColorText(value, Utils.GetLatencyColor(value, status))
            .. AddUnit("ms")
    end

    return Utils.ColorText(value, Utils.GetLatencyColor(value, status))
end

function Display:TokenText(token, data)
    if token == "fps" then
        if not InfoStripDB.display.showFPS then return "" end
        return AddLabel("fps", InfoStrip:L("fps")) .. Utils.ColorText(data.fps, Utils.GetFPSColor(data.fps))
    elseif token == "fps_value" then
        if not InfoStripDB.display.showFPS then return "" end
        return Utils.ColorText(data.fps, Utils.GetFPSColor(data.fps))
    elseif token == "home" then
        if not InfoStripDB.display.showHomeLatency then return "" end
        return self:LatencyText("home", data.homeLatency, data, true)
    elseif token == "home_value" then
        if not InfoStripDB.display.showHomeLatency then return "" end
        return self:LatencyText("home", data.homeLatency, data, false)
    elseif token == "world" then
        if not InfoStripDB.display.showWorldLatency then return "" end
        return self:LatencyText("world", data.worldLatency, data, true)
    elseif token == "world_value" then
        if not InfoStripDB.display.showWorldLatency then return "" end
        return self:LatencyText("world", data.worldLatency, data, false)
    elseif token == "total" then
        if not InfoStripDB.display.showTotalLatency then return "" end
        return self:LatencyText("total", data.totalLatency, data, true)
    elseif token == "total_value" then
        if not InfoStripDB.display.showTotalLatency then return "" end
        return self:LatencyText("total", data.totalLatency, data, false)
    elseif token == "bw_in" then
        if not InfoStripDB.display.showBandwidthIn then return "" end
        local value = Utils.FormatBandwidth(data.bandwidthIn)
        return AddLabel("bw_in", InfoStrip:L("bandwidthIn"))
            .. Utils.ColorText(value, Utils.GetBandwidthColor(data.bandwidthIn))
            .. AddUnit("KB/s")
    elseif token == "bw_in_value" then
        if not InfoStripDB.display.showBandwidthIn then return "" end
        return Utils.ColorText(Utils.FormatBandwidth(data.bandwidthIn), Utils.GetBandwidthColor(data.bandwidthIn))
    elseif token == "bw_out" then
        if not InfoStripDB.display.showBandwidthOut then return "" end
        local value = Utils.FormatBandwidth(data.bandwidthOut)
        return AddLabel("bw_out", InfoStrip:L("bandwidthOut"))
            .. Utils.ColorText(value, Utils.GetBandwidthColor(data.bandwidthOut))
            .. AddUnit("KB/s")
    elseif token == "bw_out_value" then
        if not InfoStripDB.display.showBandwidthOut then return "" end
        return Utils.ColorText(Utils.FormatBandwidth(data.bandwidthOut), Utils.GetBandwidthColor(data.bandwidthOut))
    elseif token == "speed" then
        if not InfoStripDB.display.showSpeed then return "" end
        return AddLabel("speed", InfoStrip:L("speed"))
            .. Utils.ColorText(data.speedValue, Utils.GetSpeedColor(data.speedPercent))
            .. AddUnit(data.speedUnit)
    elseif token == "speed_value" then
        if not InfoStripDB.display.showSpeed then return "" end
        return Utils.ColorText(data.speedValue, Utils.GetSpeedColor(data.speedPercent))
    elseif token == "coord" then
        if not InfoStripDB.display.showCoord or not data.coord then return "" end
        return AddLabel("coord", InfoStrip:L("coord")) .. Utils.ColorText(data.coord, Utils.GetCoordColor())
    elseif token == "coord_value" then
        if not InfoStripDB.display.showCoord or not data.coord then return "" end
        return Utils.ColorText(data.coord, Utils.GetCoordColor())
    elseif token == "region" then
        if not InfoStripDB.display.showRegion then return "" end
        return AddLabel("region", InfoStrip:L("region") .. ":") .. Utils.ColorText(data.region, Utils.GetRegionColor())
    elseif token == "region_value" then
        if not InfoStripDB.display.showRegion then return "" end
        return Utils.ColorText(data.region, Utils.GetRegionColor())
    elseif token == "date" then
        if not InfoStripDB.display.showDate then return "" end
        return AddLabel("date", InfoStrip:L("date")) .. Utils.ColorText(data.dateText, Utils.GetDateColor())
    elseif token == "date_value" then
        if not InfoStripDB.display.showDate then return "" end
        return Utils.ColorText(data.dateText, Utils.GetDateColor())
    elseif token == "local" then
        if not InfoStripDB.display.showLocalTime then return "" end
        return AddLabel("localTime", InfoStrip:L("localTime")) .. Utils.ColorText(data.localTime, Utils.GetTimeColor())
    elseif token == "local_time" then
        if not InfoStripDB.display.showLocalTime then return "" end
        return Utils.ColorText(data.localTime, Utils.GetTimeColor())
    elseif token == "server" then
        if not InfoStripDB.display.showServerTime then return "" end
        return AddLabel("serverTime", InfoStrip:L("serverTime")) .. Utils.ColorText(data.serverTime, Utils.GetTimeColor())
    elseif token == "server_time" then
        if not InfoStripDB.display.showServerTime then return "" end
        return Utils.ColorText(data.serverTime, Utils.GetTimeColor())
    end

    return "{%" .. token .. "}"
end

function Display:GetTemplateSegments(template)
    template = Utils.NormalizeTemplateFormat(template or InfoStripDB.general.template or "")

    if self.cachedTemplate ~= template then
        self.cachedTemplate = template
        self.cachedSegments = Utils.ParseTemplate(template)
    end

    return self.cachedSegments or {}
end

function Display:BuildText(template, usePreviewFallback)
    local segments = self:GetTemplateSegments(template or InfoStripDB.general.template)
    local data = self:BuildData(usePreviewFallback, segments)
    local output = {}

    for _, segment in ipairs(segments) do
        if segment.kind == "token" then
            table.insert(output, self:TokenText(segment.value, data))
        else
            table.insert(output, segment.value)
        end
    end

    local text = table.concat(output)
    if text:gsub("%s", "") == "" then
        text = Utils.ColorText("InfoStrip", Utils.MainColor())
    end

    return text
end

function Display:BuildPreviewText(template)
    return self:BuildText(template, true)
end


function Display:CreateMinimapButton()
    if self.minimapButton or not Minimap then
        return
    end

    local button = CreateFrame("Button", "InfoStripMinimapButton", Minimap)
    button:SetSize(31, 31)
    button:SetFrameStrata("MEDIUM")
    button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -2, 2)
    button:RegisterForClicks("LeftButtonUp")

    button.icon = button:CreateTexture(nil, "ARTWORK")
    button.icon:SetPoint("CENTER", button, "CENTER", -1, 1)
    button.icon:SetSize(22, 22)
    button.icon:SetTexture("Interface\\AddOns\\InfoStrip\\Media\\InfoStripIcon.tga")

    button.border = button:CreateTexture(nil, "OVERLAY")
    button.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    button.border:SetSize(54, 54)
    button.border:SetPoint("CENTER", button, "CENTER", 11, -12)

    button:SetScript("OnClick", function()
        if InfoStrip_OpenOptions then
            InfoStrip_OpenOptions()
        end
    end)
    button:SetScript("OnEnter", function(self)
        if GameTooltip then
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetText("InfoStrip")
            GameTooltip:AddLine(InfoStrip:L("clickToOpenOptions"), 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
    button:SetScript("OnLeave", function()
        if GameTooltip then GameTooltip:Hide() end
    end)

    self.minimapButton = button
end

function Display:UpdateMinimapButton()
    self:CreateMinimapButton()
    if not self.minimapButton then
        return
    end
    if InfoStripDB.general and InfoStripDB.general.showSettingsIcon then
        self.minimapButton:Show()
    else
        self.minimapButton:Hide()
    end
end

function Display:UpdateText()
    if not self.frame or not self.frame.text then
        return
    end

    local padX, padY = Utils.GetPadding()
    local textAlign = Utils.GetTextAlign()

    local displayText = self:BuildText()
    if displayText == self.lastDisplayText
        and padX == self.lastPadX
        and padY == self.lastPadY
        and textAlign == self.lastTextAlign then
        return
    end

    self.lastDisplayText = displayText
    self.lastPadX = padX
    self.lastPadY = padY
    self.lastTextAlign = textAlign

    local textSettings = InfoStripDB.appearance.text or {}
    local frameSettings = InfoStripDB.appearance.frame or {}
    local fontSize = tonumber(textSettings.fontSize) or 14
    local multiplier = tonumber(frameSettings.lineSpacingMultiplier) or 1.2
    if multiplier < 1.0 then multiplier = 1.0 end
    if multiplier > 2.0 then multiplier = 2.0 end

    local lines = SplitDisplayLines(displayText)
    local lineHeight = math.ceil(fontSize + 2)
    local lineGap = math.max(0, math.ceil(fontSize * (multiplier - 1.0)))
    local lineInfo = {}
    local maxWidth = 0

    for index, lineText in ipairs(lines) do
        local line = self:GetLineFontString(index)
        if line then
            line:ClearAllPoints()
            line:Show()
            line:SetJustifyH(textAlign)
            line:SetJustifyV("MIDDLE")
            if line.SetWordWrap then line:SetWordWrap(false) end
            if line.SetNonSpaceWrap then line:SetNonSpaceWrap(false) end

            -- Measure each display line independently. This avoids the built-in
            -- FontString ellipsis that can appear when one multi-line FontString
            -- is constrained by the previous HUD width.
            line:SetWidth(4096)
            line:SetHeight(lineHeight)
            line:SetText(lineText ~= "" and lineText or " ")

            local width = math.ceil((line:GetStringWidth() or 0) + 4)
            if width < 1 then width = 1 end

            lineInfo[index] = { line = line, width = width }
            if width > maxWidth then maxWidth = width end
        end
    end

    for index = #lines + 1, #(self.frame.lines or {}) do
        local line = self.frame.lines[index]
        if line then
            line:Hide()
        end
    end

    local totalHeight = lineHeight * #lines
    if #lines > 1 then
        totalHeight = totalHeight + lineGap * (#lines - 1)
    end

    local frameWidth = math.max(80, math.ceil(maxWidth + padX * 2))
    local frameHeight = math.max(24, math.ceil(totalHeight + padY * 2))
    self.frame:SetWidth(frameWidth)
    self.frame:SetHeight(frameHeight)

    local yOffset = padY
    for _, info in ipairs(lineInfo) do
        local line = info.line
        line:ClearAllPoints()
        line:SetWidth(info.width)
        line:SetHeight(lineHeight)

        if textAlign == "RIGHT" then
            line:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -padX, -yOffset)
        elseif textAlign == "CENTER" then
            line:SetPoint("TOP", self.frame, "TOP", 0, -yOffset)
        else
            line:SetPoint("TOPLEFT", self.frame, "TOPLEFT", padX, -yOffset)
        end

        yOffset = yOffset + lineHeight + lineGap
    end
end

function Display:OnUpdate(elapsed)
    if not InfoStripDB or not InfoStripDB.enabled then
        return
    end

    self.elapsed = (self.elapsed or 0) + elapsed

    if self.elapsed < ((InfoStripDB.general.updateIntervalMs or 1000) / 1000) then
        return
    end

    self.elapsed = 0
    self:UpdateText()
end

function Display:Initialize()
    self:CreateFrame()
    self:CreateMinimapButton()
    self:ApplySettings()
end
