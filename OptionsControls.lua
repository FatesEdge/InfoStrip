local InfoStrip = _G.InfoStrip
local Utils = InfoStrip.Utils

InfoStrip.Options = InfoStrip.Options or {}
local Options = InfoStrip.Options

Options.controls = {}

local PANEL_WIDTH = 690
local CONTENT_WIDTH = 644
local INNER_WIDTH = 614

local categoryIcon = "Interface\\AddOns\\InfoStrip\\Media\\InfoStripIcon.tga"

local languages = {
    { value = "auto", labelKey = "languageAuto" },
    { value = "enUS", label = "English" },
    { value = "zhCN", label = "简体中文" },
    { value = "zhTW", label = "繁體中文" },
    { value = "deDE", label = "Deutsch" },
    { value = "esES", label = "Español" },
    { value = "jaJP", label = "日本語" },
    { value = "koKR", label = "한국어" },
}

local colorModesThreshold = {
    { value = "followMain", labelKey = "modeFollowMain" },
    { value = "fixed", labelKey = "modeFixed" },
    { value = "thresholdCustom", labelKey = "modeThreshold" },
}

local colorModesSimple = {
    { value = "followMain", labelKey = "modeFollowMain" },
    { value = "fixed", labelKey = "modeFixed" },
}

local outlineModes = {
    { value = "NONE", labelKey = "outlineNone" },
    { value = "OUTLINE", labelKey = "outlineThin" },
    { value = "THICKOUTLINE", labelKey = "outlineThick" },
}

local speedFormats = {
    { value = "percent", labelKey = "speedPercent" },
    { value = "yards", labelKey = "speedYards" },
}

local timeFormats = {
    { value = "24h", labelKey = "timeFormat24h" },
    { value = "12h", labelKey = "timeFormat12h" },
}

local paddingModes = {
    { value = "uniform", labelKey = "paddingUniform" },
    { value = "xy", labelKey = "paddingXY" },
}

local textAlignModes = {
    { value = "LEFT", labelKey = "alignLeft" },
    { value = "CENTER", labelKey = "alignCenter" },
    { value = "RIGHT", labelKey = "alignRight" },
}

local unavailableModes = {
    { value = "hide", labelKey = "unavailableHide" },
    { value = "dash", labelKey = "unavailableDash" },
}

local precisionValues = {
    { value = 0, label = "0" },
    { value = 1, label = "1" },
    { value = 2, label = "2" },
}

local dateFormatPresets = {
    { value = "%Y-%m-%d", label = "YYYY-MM-DD" },
    { value = "%y-%m-%d", label = "YY-MM-DD" },
    { value = "%d/%m/%Y", label = "DD/MM/YYYY" },
    { value = "%d/%m/%y", label = "DD/MM/YY" },
    { value = "%Y.%m.%d", label = "YYYY.MM.DD" },
    { value = "%d %b %Y", label = "DD Mon YYYY" },
    { value = "%b %d, %Y", label = "Mon DD, YYYY" },
    { value = "%Y-%m-%d %a", label = "YYYY-MM-DD Wed" },
    { value = "%Y-%m-%d %A", label = "YYYY-MM-DD Wednesday" },
    { value = "%a, %Y-%m-%d", label = "Wed, YYYY-MM-DD" },
    { value = "%A, %d %b %Y", label = "Wednesday, DD Mon YYYY" },
}

local tokenButtonsFull = {
    { key = "fps", labelKey = "fps" },
    { key = "home", labelKey = "home" },
    { key = "world", labelKey = "world" },
    { key = "total", labelKey = "total" },
    { key = "bw_in", labelKey = "bandwidthIn" },
    { key = "bw_out", labelKey = "bandwidthOut" },
    { key = "speed", labelKey = "speed" },
    { key = "coord", labelKey = "coord" },
    { key = "date", labelKey = "date" },
    { key = "local", labelKey = "localTime" },
    { key = "server", labelKey = "serverTime" },
}

local tokenButtonsValue = {
    { key = "fps_value", labelKey = "fpsValue" },
    { key = "home_value", labelKey = "homeValue" },
    { key = "world_value", labelKey = "worldValue" },
    { key = "total_value", labelKey = "totalValue" },
    { key = "bw_in_value", labelKey = "bandwidthInValue" },
    { key = "bw_out_value", labelKey = "bandwidthOutValue" },
    { key = "speed_value", labelKey = "speedValue" },
    { key = "coord_value", labelKey = "coordValue" },
    { key = "date_value", labelKey = "dateValue" },
    { key = "local_time", labelKey = "localTimeValue" },
    { key = "server_time", labelKey = "serverTimeValue" },
}

local displayFieldItems = {
    { displayKey = "showFPS", labelKey = "showFPS", labelToggleKey = "fps", iconToggleKey = "fps" },
    { displayKey = "showHomeLatency", labelKey = "showHomeLatency", labelToggleKey = "home", iconToggleKey = "home" },
    { displayKey = "showWorldLatency", labelKey = "showWorldLatency", labelToggleKey = "world", iconToggleKey = "world" },
    { displayKey = "showTotalLatency", labelKey = "showTotalLatency", labelToggleKey = "total", iconToggleKey = "total" },
    { displayKey = "showBandwidthIn", labelKey = "showBandwidthIn", labelToggleKey = "bw_in", iconToggleKey = "bw_in" },
    { displayKey = "showBandwidthOut", labelKey = "showBandwidthOut", labelToggleKey = "bw_out", iconToggleKey = "bw_out" },
    { displayKey = "showSpeed", labelKey = "showSpeed", labelToggleKey = "speed", iconToggleKey = "speed" },
    { displayKey = "showCoord", labelKey = "showCoord", labelToggleKey = "coord", iconToggleKey = "coord" },
    { displayKey = "showDate", labelKey = "showDate", labelToggleKey = "date", iconToggleKey = "date" },
    { displayKey = "showLocalTime", labelKey = "showLocalTime", labelToggleKey = "localTime", iconToggleKey = "localTime" },
    { displayKey = "showServerTime", labelKey = "showServerTime", labelToggleKey = "serverTime", iconToggleKey = "serverTime" },
}

local function ValueLabel(values, value)
    for _, item in ipairs(values) do
        if item.value == value then
            if item.labelKey then
                return InfoStrip:L(item.labelKey)
            end
            return item.label or tostring(value)
        end
    end
    return tostring(value)
end

local function LanguageLabel(value)
    return ValueLabel(languages, value)
end


local function DateFormatPresetValue()
    local current = InfoStripDB and InfoStripDB.appearance and InfoStripDB.appearance.format and InfoStripDB.appearance.format.dateFormat or "%Y-%m-%d"
    for _, item in ipairs(dateFormatPresets) do
        if item.value == current then
            return item.value
        end
    end
    return "%Y-%m-%d"
end

local function DateFormatPresetLabel(value)
    return ValueLabel(dateFormatPresets, value)
end

local function SetDateFormatPreset(value)
    InfoStripDB.appearance.format.dateFormat = value or "%Y-%m-%d"
end

local function SetControlEnabled(control, enabled)
    if enabled then
        if control.Enable then control:Enable() end
        control:EnableMouse(true)
        control:SetAlpha(1.0)
    else
        if control.Disable then control:Disable() end
        control:EnableMouse(false)
        control:SetAlpha(0.35)
    end
end


local function ShowInfoTooltip(owner, title, hint)
    if GameTooltip and title then
        GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
        GameTooltip:SetText(tostring(title or ""))
        if hint and hint ~= "" then
            GameTooltip:AddLine(tostring(hint or ""), 1, 1, 1, true)
        end
        GameTooltip:Show()
    end
end

local function HideInfoTooltip()
    if GameTooltip then
        GameTooltip:Hide()
    end
end

local function DefaultTooltipHint(title)
    local hints = {
        [InfoStrip:L("enabled")] = InfoStrip:L("hintEnabled"),
        [InfoStrip:L("showSettingsIcon")] = InfoStrip:L("hintShowSettingsIcon"),
        [InfoStrip:L("language")] = InfoStrip:L("hintLanguage"),
        [InfoStrip:L("locked")] = InfoStrip:L("hintLocked"),
        [InfoStrip:L("resetPosition")] = InfoStrip:L("hintResetPosition"),
        [InfoStrip:L("updateIntervalMs")] = InfoStrip:L("hintUpdateInterval"),
        [InfoStrip:L("dateFormat")] = InfoStrip:L("hintDateFormat"),
        [InfoStrip:L("timeFormat")] = InfoStrip:L("hintTimeFormat"),
        [InfoStrip:L("showSeconds")] = InfoStrip:L("hintShowSeconds"),
        [InfoStrip:L("speedFormat")] = InfoStrip:L("hintSpeedFormat"),
        [InfoStrip:L("outdoorOnly")] = InfoStrip:L("hintCoordOption"),
        [InfoStrip:L("hideInCombat")] = InfoStrip:L("hintCoordOption"),
        [InfoStrip:L("hideInInstance")] = InfoStrip:L("hintCoordOption"),
        [InfoStrip:L("unavailableMode")] = InfoStrip:L("hintCoordOption"),
        [InfoStrip:L("coordPrecision")] = InfoStrip:L("hintCoordOption"),
        [InfoStrip:L("font")] = InfoStrip:L("hintFont"),
        [InfoStrip:L("fontSize")] = InfoStrip:L("hintFontSize"),
        [InfoStrip:L("outline")] = InfoStrip:L("hintOutline"),
        [InfoStrip:L("bold")] = InfoStrip:L("hintBold"),
        [InfoStrip:L("shadow")] = InfoStrip:L("hintShadow"),
        [InfoStrip:L("shadowAlpha")] = InfoStrip:L("hintAlpha"),
        [InfoStrip:L("shadowOffsetX")] = InfoStrip:L("hintShadowOffset"),
        [InfoStrip:L("shadowOffsetY")] = InfoStrip:L("hintShadowOffset"),
        [InfoStrip:L("mainTextColor")] = InfoStrip:L("hintMainTextColor"),
        [InfoStrip:L("background")] = InfoStrip:L("hintBackground"),
        [InfoStrip:L("backgroundColor")] = InfoStrip:L("hintBackgroundColor"),
        [InfoStrip:L("backgroundAlpha")] = InfoStrip:L("hintAlpha"),
        [InfoStrip:L("border")] = InfoStrip:L("hintBorder"),
        [InfoStrip:L("borderColor")] = InfoStrip:L("hintBorderColor"),
        [InfoStrip:L("borderAlpha")] = InfoStrip:L("hintAlpha"),
        [InfoStrip:L("borderSize")] = InfoStrip:L("hintBorderSize"),
        [InfoStrip:L("cornerRadius")] = InfoStrip:L("hintCornerRadius"),
        [InfoStrip:L("paddingMode")] = InfoStrip:L("hintPaddingMode"),
        [InfoStrip:L("padding")] = InfoStrip:L("hintPadding"),
        [InfoStrip:L("paddingX")] = InfoStrip:L("hintPadding"),
        [InfoStrip:L("paddingY")] = InfoStrip:L("hintPadding"),
        [InfoStrip:L("lineSpacing")] = InfoStrip:L("hintLineSpacing"),
        [InfoStrip:L("colorMode")] = InfoStrip:L("hintColorMode"),
        [InfoStrip:L("fixedColor")] = InfoStrip:L("hintFixedColor"),
        [InfoStrip:L("fpsWarningBelow")] = InfoStrip:L("hintThresholdValue"),
        [InfoStrip:L("fpsBadBelow")] = InfoStrip:L("hintThresholdValue"),
        [InfoStrip:L("latencyWarningAbove")] = InfoStrip:L("hintThresholdValue"),
        [InfoStrip:L("latencyBadAbove")] = InfoStrip:L("hintThresholdValue"),
        [InfoStrip:L("bandwidthWarningAbove")] = InfoStrip:L("hintThresholdValue"),
        [InfoStrip:L("bandwidthBadAbove")] = InfoStrip:L("hintThresholdValue"),
        [InfoStrip:L("template")] = InfoStrip:L("hintTemplate"),
    }
    return hints[title]
end

local function StyleOptionRow(row, title, hint)
    if not row then return end
    row:EnableMouse(true)

    local highlight = row:CreateTexture(nil, "BACKGROUND")
    highlight:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
    highlight:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 0)
    highlight:SetColorTexture(1, 0.82, 0, 0.08)
    highlight:Hide()
    row.highlight = highlight
    row.tooltipTitle = title
    row.tooltipHint = hint or DefaultTooltipHint(title)

    row:HookScript("OnEnter", function(self)
        if self.highlight then
            self.highlight:Show()
        end
        if self.tooltipHint and self.tooltipHint ~= "" then
            ShowInfoTooltip(self, self.tooltipTitle, self.tooltipHint)
        end
    end)

    row:HookScript("OnLeave", function(self)
        if self.highlight then self.highlight:Hide() end
        HideInfoTooltip()
    end)
end

local function AttachRowHoverToChild(row, child)
    if not row or not child then return end
    local isCheckButton = child.GetObjectType and child:GetObjectType() == "CheckButton"
    if isCheckButton then
        local highlightTexture = child.GetHighlightTexture and child:GetHighlightTexture()
        if highlightTexture and highlightTexture.SetAlpha then
            highlightTexture:SetAlpha(0)
        end
        if child.HoverBackground and child.HoverBackground.SetAlpha then
            child.HoverBackground:SetAlpha(0)
        end
    end
    child:HookScript("OnEnter", function(self)
        if row.highlight then
            row.highlight:Show()
        end
        if row.tooltipHint and row.tooltipHint ~= "" then
            ShowInfoTooltip(self, row.tooltipTitle, row.tooltipHint)
        end
    end)
    child:HookScript("OnLeave", function()
        if row.highlight then row.highlight:Hide() end
        HideInfoTooltip()
    end)
end


local function SetShouldDisplay(control, predicate)
    if not control then return control end
    control.ShouldDisplay = predicate
    local visible = true
    if predicate then
        visible = predicate() and true or false
    end
    control:SetShown(visible)
    if not visible and control.SetHeight then
        control:SetHeight(1)
    end
    return control
end


function Options:RegisterControl(control)
    table.insert(self.controls, control)
end

function Options:Refresh()
    if self.refreshing then
        return
    end

    self.refreshing = true

    for _, control in ipairs(self.controls) do
        if control.ShouldDisplay then
            control:SetShown(control:ShouldDisplay())
        end
        if control.Refresh then
            control:Refresh()
        end
    end

    for _, panel in ipairs({ self.generalPanel, self.appearancePanel, self.advancedPanel }) do
        if panel and panel.Layout then
            panel:Layout()
            if panel.UpdateScrollHeight then
                panel:UpdateScrollHeight()
            end
        end
    end

    self:UpdatePreview()
    self.refreshing = false
end

local function AttachPanelLayout(panel)
    local layoutIndex = 0
    function panel:GetLayoutIndex()
        layoutIndex = layoutIndex + 1
        return layoutIndex
    end

    function panel:UpdateScrollHeight()
        local children = { self:GetChildren() }
        table.sort(children, function(a, b)
            return (a.layoutIndex or 99999) < (b.layoutIndex or 99999)
        end)

        local totalHeight = 20
        for _, child in ipairs(children) do
            if child.ShouldDisplay then
                child:SetShown(child:ShouldDisplay())
            end
            if child:IsShown() and child.layoutIndex then
                if child.RefreshLayout then
                    child:RefreshLayout()
                end
                totalHeight = totalHeight + (child:GetHeight() or 0) + (child.bottomPadding or 0) + (self.spacing or 0)
            end
        end

        self:SetHeight(math.max(totalHeight, 620))
        if self.scrollView and self.scrollView.SetElementExtent then
            self.scrollView:SetElementExtent(self:GetHeight())
        end
        if self.scrollElementFrame then
            self.scrollElementFrame:SetHeight(self:GetHeight())
        end
        if self.scrollBox and self.scrollBox.FullUpdate then
            self.scrollBox:FullUpdate(ScrollBoxConstants and ScrollBoxConstants.UpdateImmediately)
        end
    end
end

local fallbackPanelCounter = 0

local function StyleFallbackScrollFrame(scrollFrame, scrollName)
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local range = self:GetVerticalScrollRange() or 0
        local current = self:GetVerticalScroll() or 0
        local nextValue = current - (delta * 44)
        if nextValue < 0 then
            nextValue = 0
        elseif nextValue > range then
            nextValue = range
        end
        self:SetVerticalScroll(nextValue)
    end)

    local scrollBar = scrollFrame.ScrollBar or _G[scrollName .. "ScrollBar"]
    if scrollBar then
        scrollBar:SetWidth(12)
        scrollBar:ClearAllPoints()
        scrollBar:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", 17, -18)
        scrollBar:SetPoint("BOTTOMRIGHT", scrollFrame, "BOTTOMRIGHT", 17, 18)

        if scrollBar.ThumbTexture then
            scrollBar.ThumbTexture:SetWidth(8)
        elseif _G[scrollName .. "ScrollBarThumbTexture"] then
            _G[scrollName .. "ScrollBarThumbTexture"]:SetWidth(8)
        end

        local upButton = scrollBar.ScrollUpButton or _G[scrollName .. "ScrollBarScrollUpButton"]
        local downButton = scrollBar.ScrollDownButton or _G[scrollName .. "ScrollBarScrollDownButton"]
        if upButton then upButton:SetSize(14, 14) end
        if downButton then downButton:SetSize(14, 14) end
    end
end

local function CreateFallbackPanel()
    local outer = CreateFrame("Frame", nil)
    outer:SetSize(760, 620)

    fallbackPanelCounter = fallbackPanelCounter + 1
    local scrollName = "InfoStripOptionsScrollFrame" .. fallbackPanelCounter
    local scrollFrame = CreateFrame("ScrollFrame", scrollName, outer, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", outer, "TOPLEFT", 0, -2)
    scrollFrame:SetPoint("BOTTOMRIGHT", outer, "BOTTOMRIGHT", -28, 2)
    StyleFallbackScrollFrame(scrollFrame, scrollName)

    local panel = CreateFrame("Frame", nil, scrollFrame, "VerticalLayoutFrame")
    panel.spacing = 5
    panel:SetWidth(PANEL_WIDTH)
    panel:SetHeight(620)
    scrollFrame:SetScrollChild(panel)

    panel.outerPanel = outer
    panel.scrollFrame = scrollFrame
    AttachPanelLayout(panel)

    outer:SetScript("OnShow", function()
        if panel.Layout then
            panel:Layout()
        end
        panel:UpdateScrollHeight()
        Options:UpdatePreview()
    end)

    return panel
end

local function CreateScrollBoxPanel()
    local outer = CreateFrame("Frame", nil)
    outer:SetSize(760, 620)

    local scrollBox = CreateFrame("Frame", nil, outer, "WowScrollBoxList")
    scrollBox:SetPoint("TOPLEFT", outer, "TOPLEFT", 0, -2)
    scrollBox:SetPoint("BOTTOMRIGHT", outer, "BOTTOMRIGHT", -22, 2)

    local scrollBar = CreateFrame("EventFrame", nil, outer, "MinimalScrollBar")
    scrollBar:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 4, 0)
    scrollBar:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 4, 0)

    local panel = CreateFrame("Frame", nil, nil, "VerticalLayoutFrame")
    panel.spacing = 5
    panel:SetWidth(PANEL_WIDTH)
    panel:SetHeight(620)
    panel.outerPanel = outer
    panel.scrollBox = scrollBox
    panel.scrollBar = scrollBar
    AttachPanelLayout(panel)

    local view = CreateScrollBoxListLinearView()
    panel.scrollView = view
    view:SetElementExtent(620)
    view:SetElementInitializer("InfoStripScrollBoxElementTemplate", function(frame)
        panel.scrollElementFrame = frame
        panel:SetParent(frame)
        panel:ClearAllPoints()
        panel:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
        panel:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
        frame:SetHeight(panel:GetHeight() or 620)
    end)

    if ScrollUtil.InitScrollBoxListWithScrollBar then
        ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBar, view)
    else
        ScrollUtil.InitScrollBoxWithScrollBar(scrollBox, scrollBar, view)
    end
    local dataProvider = CreateDataProvider()
    if dataProvider.Insert then
        dataProvider:Insert({ id = "content" })
    else
        dataProvider:InsertTable({ { id = "content" } })
    end
    scrollBox:SetDataProvider(dataProvider)

    if view.SetPanExtent then
        view:SetPanExtent(28)
    end
    if scrollBox.SetPanExtent then
        scrollBox:SetPanExtent(28)
    end
    scrollBox:EnableMouseWheel(true)
    scrollBox:SetScript("OnMouseWheel", function(self, delta)
        local visibleHeight = self:GetHeight() or 620
        local contentHeight = panel:GetHeight() or 620
        local range = math.max(contentHeight - visibleHeight, 0)
        if range <= 0 then
            return
        end

        local current = 0
        if self.GetScrollOffset then
            current = self:GetScrollOffset() or 0
        elseif self.GetDerivedScrollOffset then
            current = self:GetDerivedScrollOffset() or 0
        elseif self.GetScrollPercentage then
            current = (self:GetScrollPercentage() or 0) * range
        end

        local nextValue = math.max(0, math.min(range, current - delta * 36))
        if self.ScrollToOffset then
            self:ScrollToOffset(nextValue)
        elseif self.SetScrollPercentage then
            self:SetScrollPercentage(nextValue / range)
        elseif self.SetScrollTarget then
            self:SetScrollTarget(nextValue)
        end
    end)

    outer:SetScript("OnShow", function()
        if panel.Layout then
            panel:Layout()
        end
        panel:UpdateScrollHeight()
        Options:UpdatePreview()
    end)

    return panel
end

local function CreatePanel()
    if CreateScrollBoxListLinearView and ScrollUtil and CreateDataProvider then
        local ok, panel = pcall(CreateScrollBoxPanel)
        if ok and panel then
            return panel
        end
    end
    return CreateFallbackPanel()
end

local function CreateDividerHeader(parent, title, description)
    local header = CreateFrame("Frame", nil, parent)
    header:SetSize(CONTENT_WIDTH, description and 94 or 78)

    local text = header:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    text:SetPoint("TOPLEFT", 7, -12)
    text:SetWidth(CONTENT_WIDTH - 30)
    text:SetJustifyH("LEFT")
    text:SetText(title)
    text:SetScale(1.36)

    if NORMAL_FONT_COLOR and NORMAL_FONT_COLOR.GetRGB then
        text:SetTextColor(NORMAL_FONT_COLOR:GetRGB())
    else
        text:SetTextColor(1, 0.82, 0)
    end

    if description and description ~= "" then
        local desc = header:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        desc:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -8)
        desc:SetWidth(CONTENT_WIDTH - 40)
        desc:SetJustifyH("LEFT")
        desc:SetText(description)
        desc:SetTextColor(0.86, 0.86, 0.86)
    end

    local divider = header:CreateTexture(nil, "ARTWORK")
    divider:SetAtlas("Options_HorizontalDivider", true)
    divider:SetPoint("BOTTOMLEFT", -50, 0)
    divider:SetPoint("BOTTOMRIGHT", 10, 0)

    header.layoutIndex = parent:GetLayoutIndex()
    header.bottomPadding = 6
    return header
end

local function CreateSectionDivider(parent)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(CONTENT_WIDTH, 24)

    local divider = frame:CreateTexture(nil, "ARTWORK")
    divider:SetAtlas("Options_HorizontalDivider", true)
    divider:SetPoint("CENTER", frame, "CENTER", 0, 0)

    frame.layoutIndex = parent:GetLayoutIndex()
    frame.bottomPadding = 4
    return frame
end

local function CreateTextBlock(parent, text, height, fontObject)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(CONTENT_WIDTH, height or 34)

    local fs = frame:CreateFontString(nil, "ARTWORK", fontObject or "GameFontHighlight")
    fs:SetPoint("TOPLEFT", 7, -4)
    fs:SetWidth(CONTENT_WIDTH - 40)
    fs:SetJustifyH("LEFT")
    fs:SetText(text)

    frame.text = fs
    frame.layoutIndex = parent:GetLayoutIndex()
    frame.bottomPadding = 4
    return frame
end


local function CreateSectionHeader(parent, title, resetLabel, onReset, hint)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(CONTENT_WIDTH, 34)

    local resetWidth = resetLabel == InfoStrip:L("resetAllColors") and 205 or 135
    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    text:SetPoint("LEFT", 7, 0)
    text:SetWidth(onReset and (CONTENT_WIDTH - resetWidth - 36) or (CONTENT_WIDTH - 40))
    text:SetJustifyH("LEFT")
    text:SetText(title)

    if onReset then
        local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        button:SetSize(resetWidth, 24)
        button:SetPoint("RIGHT", frame, "RIGHT", -12, 0)
        button:SetText(resetLabel)
        button:SetScript("OnClick", function()
            onReset()
            InfoStrip.Display:ApplySettings()
            Options:Refresh()
        end)
        button:SetScript("OnEnter", function(self)
            ShowInfoTooltip(self, resetLabel, hint or InfoStrip:L("hintResetSection"))
        end)
        button:SetScript("OnLeave", HideInfoTooltip)
        frame.resetButton = button
    end

    frame.layoutIndex = parent:GetLayoutIndex()
    frame.bottomPadding = 4
    return frame
end

local function ResetTableSection(target, defaults)
    if type(target) ~= "table" or type(defaults) ~= "table" then
        return
    end
    for key in pairs(target) do
        target[key] = nil
    end
    Utils.ApplyDefaults(target, defaults)
end

local function CreateBoxSubHeader(parent, label)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(CONTENT_WIDTH, 24)

    local text = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    text:SetPoint("LEFT", 7, 0)
    text:SetText(label)

    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 0
    return row
end

local function CreateBox(parent, options)
    options = options or {}
    local wrapper = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    wrapper:SetSize(CONTENT_WIDTH, 42)
    wrapper.layoutIndex = parent:GetLayoutIndex()
    wrapper.bottomPadding = options.bottomPadding or 10

    local backdrop = wrapper
    if options.backdropInsetLeft or options.backdropInsetRight then
        backdrop = CreateFrame("Frame", nil, wrapper, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", wrapper, "TOPLEFT", options.backdropInsetLeft or 0, 0)
        backdrop:SetPoint("BOTTOMRIGHT", wrapper, "BOTTOMRIGHT", -(options.backdropInsetRight or 0), 0)
        if backdrop.SetFrameLevel and wrapper.GetFrameLevel then
            backdrop:SetFrameLevel(wrapper:GetFrameLevel())
        end
    end

    backdrop:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 12,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    backdrop:SetBackdropColor(0, 0, 0, 0.52)
    backdrop:SetBackdropBorderColor(1, 1, 1, 0.24)
    wrapper.backdropFrame = backdrop

    local layoutIndex = 0
    function wrapper:GetLayoutIndex()
        layoutIndex = layoutIndex + 1
        return layoutIndex
    end

    function wrapper:RefreshLayout()
        local children = { self:GetChildren() }
        table.sort(children, function(a, b)
            return (a.layoutIndex or 99999) < (b.layoutIndex or 99999)
        end)

        local childLeft = options.childLeft or 16
        local y = -(options.topPadding or 14)
        local height = options.baseHeight or 22
        for _, child in ipairs(children) do
            if child ~= backdrop and child.layoutIndex then
                local shouldDisplay = true
                if child.ShouldDisplay then
                    shouldDisplay = child:ShouldDisplay()
                end

                if shouldDisplay then
                    child:Show()
                    child:ClearAllPoints()
                    child:SetPoint("TOPLEFT", self, "TOPLEFT", childLeft, y)
                    if child.SetWidth then
                        child:SetWidth(options.childWidth or INNER_WIDTH)
                    end
                    local childHeight = (child:GetHeight() or 28) + (child.bottomPadding or 4)
                    y = y - childHeight
                    height = height + childHeight
                else
                    child:Hide()
                end
            end
        end

        self:SetHeight(math.max(height + (options.bottomInnerPadding or 14), options.minHeight or 44))
    end

    function wrapper:Refresh()
        local visible = true
        if self.ShouldDisplay then
            visible = self:ShouldDisplay()
        end
        self:SetShown(visible)
        if visible then
            self:RefreshLayout()
        else
            self:SetHeight(1)
        end
    end

    wrapper:SetScript("OnShow", function(self)
        self:Refresh()
    end)

    Options:RegisterControl(wrapper)
    return wrapper
end

local function CreateContentBox(parent)
    return CreateBox(parent, {
        childLeft = 16,
        childWidth = INNER_WIDTH,
    })
end

local function CreateIndentedContentBox(parent)
    return CreateBox(parent, {
        backdropInsetLeft = 7,
        childLeft = 23,
        childWidth = INNER_WIDTH,
    })
end

local function CreateCheck(parent, label, getter, setter, enabledGetter)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(CONTENT_WIDTH, 28)

    local check = CreateFrame("CheckButton", nil, row, "SettingsCheckBoxTemplate")
    check:SetPoint("LEFT", 7, 0)
    check:SetSize(21, 20)

    local text = check:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    text:SetPoint("LEFT", check, "RIGHT", 4, 0)
    text:SetText(label)

    function row:Refresh()
        check:SetChecked(getter() and true or false)
        if enabledGetter then
            SetControlEnabled(check, enabledGetter())
            text:SetAlpha(enabledGetter() and 1 or 0.35)
        end
    end

    check:SetScript("OnClick", function()
        setter(check:GetChecked())
        InfoStrip.Display:ApplySettings()
        Options:Refresh()
    end)

    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 2
    StyleOptionRow(row, label)
    AttachRowHoverToChild(row, check)
    row:Refresh()
    Options:RegisterControl(row)
    return row
end

local function CreateDisplayFieldList(parent)
    local box = CreateContentBox(parent)
    box.bottomPadding = 12

    local header = CreateFrame("Frame", nil, box)
    header:SetSize(INNER_WIDTH, 28)
    header.layoutIndex = box:GetLayoutIndex()
    header.bottomPadding = 4

    local fieldTitle = header:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    fieldTitle:SetPoint("LEFT", 8, 0)
    fieldTitle:SetText(InfoStrip:L("fieldColumn"))

    local showTitle = header:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    showTitle:SetPoint("LEFT", 400, 0)
    showTitle:SetText(InfoStrip:L("showColumn"))

    local labelTitle = header:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    labelTitle:SetPoint("LEFT", 480, 0)
    labelTitle:SetText(InfoStrip:L("labelColumn"))

    local iconTitle = header:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    iconTitle:SetPoint("LEFT", 560, 0)
    iconTitle:SetText(InfoStrip:L("iconColumn"))

    for _, item in ipairs(displayFieldItems) do
        local row = CreateFrame("Frame", nil, box)
        row:SetSize(INNER_WIDTH, 34)
        row.layoutIndex = box:GetLayoutIndex()
        row.bottomPadding = 2
        StyleOptionRow(row, InfoStrip:L(item.labelKey), InfoStrip:L("displayFieldRowHint"))

        local label = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        label:SetPoint("LEFT", 8, 0)
        label:SetWidth(370)
        label:SetJustifyH("LEFT")
        label:SetText(InfoStrip:L(item.labelKey))

        local showCheck = CreateFrame("CheckButton", nil, row, "SettingsCheckBoxTemplate")
        showCheck:SetPoint("LEFT", 406, 0)
        showCheck:SetSize(21, 20)

        local labelCheck = CreateFrame("CheckButton", nil, row, "SettingsCheckBoxTemplate")
        labelCheck:SetPoint("LEFT", 486, 0)
        labelCheck:SetSize(21, 20)

        local iconCheck = CreateFrame("CheckButton", nil, row, "SettingsCheckBoxTemplate")
        iconCheck:SetPoint("LEFT", 566, 0)
        iconCheck:SetSize(21, 20)

        function row:Refresh()
            local visible = InfoStripDB.display[item.displayKey] and true or false
            InfoStripDB.general.labels = InfoStripDB.general.labels or {}
            InfoStripDB.general.icons = InfoStripDB.general.icons or {}
            showCheck:SetChecked(visible)
            labelCheck:SetChecked(InfoStripDB.general.labels[item.labelToggleKey] ~= false)
            iconCheck:SetChecked(InfoStripDB.general.icons[item.iconToggleKey] == true)
            SetControlEnabled(labelCheck, visible)
            SetControlEnabled(iconCheck, visible)
            label:SetAlpha(visible and 1 or 0.55)
        end

        showCheck:SetScript("OnClick", function()
            Utils.SetDisplayItemEnabled(item.displayKey, showCheck:GetChecked())
            InfoStrip.Display:ApplySettings()
            Options:Refresh()
        end)

        labelCheck:SetScript("OnClick", function()
            InfoStripDB.general.labels = InfoStripDB.general.labels or {}
            InfoStripDB.general.labels[item.labelToggleKey] = labelCheck:GetChecked() and true or false
            InfoStrip.Display:ApplySettings()
            Options:Refresh()
        end)

        iconCheck:SetScript("OnClick", function()
            InfoStripDB.general.icons = InfoStripDB.general.icons or {}
            InfoStripDB.general.icons[item.iconToggleKey] = iconCheck:GetChecked() and true or false
            InfoStrip.Display:ApplySettings()
            Options:Refresh()
        end)

        AttachRowHoverToChild(row, showCheck)
        AttachRowHoverToChild(row, labelCheck)
        AttachRowHoverToChild(row, iconCheck)
        row:Refresh()
        Options:RegisterControl(row)
    end

    box:RefreshLayout()
    return box
end

local function CreateButton(parent, label, width, onClick, enabledGetter, hint)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(width or 120, 24)
    button:SetText(label)
    button:SetScript("OnClick", onClick)

    if hint then
        button:SetScript("OnEnter", function(self)
            ShowInfoTooltip(self, label, hint)
        end)
        button:SetScript("OnLeave", function()
            HideInfoTooltip()
        end)
    end

    function button:Refresh()
        if enabledGetter then
            SetControlEnabled(self, enabledGetter())
        end
    end

    button:Refresh()
    Options:RegisterControl(button)
    return button
end

local function CreateButtonRow(parent, buttons, tooltipTitle, tooltipHint)
    local row = CreateFrame("Frame", nil, parent)
    local maxWidth = INNER_WIDTH
    local x, y = 7, 0
    local rowHeight = 30

    for _, spec in ipairs(buttons) do
        local width = spec.width or 90
        if x > 7 and (x + width) > maxWidth then
            x = 7
            y = y - 30
            rowHeight = rowHeight + 30
        end

        local button = CreateButton(row, spec.label, width, spec.onClick, spec.enabledGetter, spec.hint)
        button:SetPoint("TOPLEFT", row, "TOPLEFT", x, y)
        x = x + width + 8
    end

    row:SetSize(CONTENT_WIDTH, rowHeight)
    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 4
    if tooltipTitle or tooltipHint then
        StyleOptionRow(row, tooltipTitle or "", tooltipHint)
    end
    return row
end

local function CreateDropdown(parent, label, values, labelFunc, getter, setter, enabledGetter)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(CONTENT_WIDTH, 52)

    local labelText = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    labelText:SetPoint("TOPLEFT", 7, -3)
    labelText:SetText(label)

    local dropdown = CreateFrame("Frame", nil, row, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", -9, -22)
    UIDropDownMenu_SetWidth(dropdown, 155)

    UIDropDownMenu_Initialize(dropdown, function()
        for _, value in ipairs(values) do
            local realValue = type(value) == "table" and value.value or value
            local textValue = type(value) == "table" and (value.label or InfoStrip:L(value.labelKey)) or labelFunc(realValue)

            local info = UIDropDownMenu_CreateInfo()
            info.text = textValue
            info.checked = getter() == realValue
            info.func = function()
                setter(realValue)
                UIDropDownMenu_SetText(dropdown, textValue)
                CloseDropDownMenus()
                InfoStrip.Display:ApplySettings()
                Options:Refresh()
            end
            UIDropDownMenu_AddButton(info)
        end
    end)

    function row:Refresh()
        UIDropDownMenu_SetText(dropdown, labelFunc(getter()))
        if enabledGetter then
            local enabled = enabledGetter()
            SetControlEnabled(dropdown, enabled)
            labelText:SetAlpha(enabled and 1 or 0.35)
        end
    end

    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 4
    StyleOptionRow(row, label)
    row:Refresh()
    Options:RegisterControl(row)
    return row, dropdown
end

local function FormatNumberText(value)
    value = tonumber(value) or 0
    if math.floor(value) == value then
        return tostring(value)
    end
    return tostring(tonumber(string.format("%.2f", value)))
end

local function FormatWithSuffix(value, suffix)
    local text = FormatNumberText(value)
    if suffix and suffix ~= "" then
        return text .. " " .. suffix
    end
    return text
end

local function CreateNumberRow(parent, label, minValue, maxValue, step, getter, setter, enabledGetter, suffix)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(CONTENT_WIDTH, 66)

    local labelText = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    labelText:SetPoint("TOPLEFT", 7, -3)
    labelText:SetText(label)

    local slider = CreateFrame("Slider", nil, row, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", 7, -36)
    slider:SetWidth(305)
    slider:SetMinMaxValues(minValue, maxValue)
    slider:SetValueStep(step)
    if slider.SetObeyStepOnDrag then
        slider:SetObeyStepOnDrag(true)
    end
    if slider.Low then slider.Low:SetText(FormatWithSuffix(minValue, suffix)) end
    if slider.High then slider.High:SetText(FormatWithSuffix(maxValue, suffix)) end
    if slider.Text then slider.Text:SetText(FormatWithSuffix(getter(), suffix)) end

    local editBox = CreateFrame("EditBox", nil, row, "InputBoxTemplate")
    editBox:SetPoint("LEFT", slider, "RIGHT", 16, 0)
    editBox:SetSize(74, 24)
    editBox:SetAutoFocus(false)
    editBox:SetNumeric(false)
    editBox:SetJustifyH("CENTER")
    if editBox.SetFontObject and GameFontHighlightSmall then
        editBox:SetFontObject(GameFontHighlightSmall)
    elseif editBox.SetFont and STANDARD_TEXT_FONT then
        editBox:SetFont(STANDARD_TEXT_FONT, 12, "")
    end
    if editBox.SetTextColor then
        editBox:SetTextColor(1, 1, 1, 1)
    end
    if editBox.SetTextInsets then
        editBox:SetTextInsets(4, 4, 0, 0)
    end
    if editBox.SetMaxLetters then
        editBox:SetMaxLetters(8)
    end

    local suffixText = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    suffixText:SetPoint("LEFT", editBox, "RIGHT", 6, 0)
    suffixText:SetText(suffix or "")

    local refreshing = false
    local function UpdateNumberWidgets(value)
        value = tonumber(value) or minValue
        local text = FormatNumberText(value)
        refreshing = true
        slider:SetValue(value)
        editBox:Show()
        editBox:SetText(text)
        if editBox.SetCursorPosition then
            editBox:SetCursorPosition(0)
        end
        if slider.Text then slider.Text:SetText(FormatWithSuffix(value, suffix)) end
        refreshing = false
    end

    local function SetValue(value)
        value = Utils.ClampNumber(value, minValue, maxValue, step)
        if not value then
            value = getter()
        end
        setter(value)
        InfoStrip.Display:ApplySettings()
        local finalValue = tonumber(getter()) or value or minValue
        UpdateNumberWidgets(finalValue)
        Options:Refresh()
    end

    function row:Refresh()
        local value = tonumber(getter()) or minValue
        UpdateNumberWidgets(value)

        if enabledGetter then
            local enabled = enabledGetter()
            SetControlEnabled(slider, enabled)
            SetControlEnabled(editBox, enabled)
            labelText:SetAlpha(enabled and 1 or 0.35)
            suffixText:SetAlpha(enabled and 1 or 0.35)
        end
    end

    slider:SetScript("OnValueChanged", function(_, value)
        if refreshing then return end
        SetValue(value)
    end)

    editBox:SetScript("OnEnterPressed", function(self)
        SetValue(self:GetText())
        self:ClearFocus()
    end)
    editBox:SetScript("OnEditFocusLost", function(self)
        if not refreshing then
            SetValue(self:GetText())
        end
    end)

    row:SetScript("OnShow", function(self)
        self:Refresh()
    end)

    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 4
    StyleOptionRow(row, label)
    AttachRowHoverToChild(row, slider)
    AttachRowHoverToChild(row, editBox)
    row:Refresh()
    Options:RegisterControl(row)
    return row
end

local function OpenColorPicker(color, onChanged)
    local previous = { r = color.r, g = color.g, b = color.b, a = color.a }

    ColorPickerFrame:SetupColorPickerAndShow({
        r = color.r or 1,
        g = color.g or 1,
        b = color.b or 1,
        opacity = color.a,
        hasOpacity = color.a ~= nil,
        swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB()
            color.r, color.g, color.b = r, g, b
            if color.a ~= nil then
                color.a = ColorPickerFrame:GetColorAlpha()
            end
            if onChanged then onChanged() end
            InfoStrip.Display:ApplySettings()
            Options:Refresh()
        end,
        opacityFunc = function()
            if color.a ~= nil then
                color.a = ColorPickerFrame:GetColorAlpha()
            end
            if onChanged then onChanged() end
            InfoStrip.Display:ApplySettings()
            Options:Refresh()
        end,
        cancelFunc = function()
            color.r, color.g, color.b = previous.r, previous.g, previous.b
            if previous.a ~= nil then
                color.a = previous.a
            end
            if onChanged then onChanged() end
            InfoStrip.Display:ApplySettings()
            Options:Refresh()
        end,
    })
end

local function CreateColorSwatch(parent, label, x, y, colorGetter, enabledGetter, onChanged)
    local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
    button:SetSize(38, 20)
    button:SetPoint("TOPLEFT", x or 7, y or -4)
    button:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        tileSize = 0,
        edgeSize = 10,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    button:SetBackdropColor(0, 0, 0, 0.65)
    button:SetBackdropBorderColor(1, 1, 1, 0.28)

    local texture = button:CreateTexture(nil, "ARTWORK")
    texture:SetPoint("TOPLEFT", 4, -4)
    texture:SetPoint("BOTTOMRIGHT", -4, 4)
    texture:SetTexture("Interface\\Buttons\\WHITE8x8")

    local text = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    text:SetPoint("LEFT", button, "RIGHT", 8, 0)
    text:SetWidth(92)
    text:SetJustifyH("LEFT")
    text:SetText(label)

    function button:Refresh()
        local color = colorGetter()
        texture:SetColorTexture(color.r or 1, color.g or 1, color.b or 1, color.a or 1)
        local enabled = not enabledGetter or enabledGetter()
        SetControlEnabled(self, enabled)
        text:SetAlpha(enabled and 1 or 0.35)
        self:SetBackdropBorderColor(1, 1, 1, enabled and 0.36 or 0.12)
    end

    button:SetScript("OnClick", function()
        if enabledGetter and not enabledGetter() then
            return
        end
        OpenColorPicker(colorGetter(), onChanged)
    end)
    button:SetScript("OnEnter", function(self)
        if not enabledGetter or enabledGetter() then
            self:SetBackdropBorderColor(1, 0.82, 0.25, 0.9)
        end
        ShowInfoTooltip(self, label, InfoStrip:L("colorSwatchHint"))
    end)
    button:SetScript("OnLeave", function(self)
        self:Refresh()
        HideInfoTooltip()
    end)

    button:Refresh()
    Options:RegisterControl(button)
    return button
end

local function CreateColorSwatchRow(parent, specs, shouldDisplay, height)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(INNER_WIDTH, height or 34)

    local x = 7
    for _, spec in ipairs(specs) do
        CreateColorSwatch(row, spec.label, x, spec.y or -5, spec.colorGetter, spec.enabledGetter, spec.onChanged)
        x = x + (spec.width or 148)
    end

    row.ShouldDisplay = shouldDisplay
    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 4
    return row
end

local function CreateColorRow(parent, label, colorGetter, enabledGetter, onChanged)
    return CreateColorSwatchRow(parent, {{
        label = label,
        y = -3,
        colorGetter = colorGetter,
        enabledGetter = enabledGetter,
        onChanged = onChanged,
    }}, nil, 30)
end


local function CreateFontColorBoldRow(parent, fontLabel, colorLabel, boldLabel, fontValues, fontLabelFunc, fontGetter, fontSetter, colorGetter, boldGetter, boldSetter)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(CONTENT_WIDTH, 54)

    local fontText = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    fontText:SetPoint("TOPLEFT", 7, -3)
    fontText:SetText(fontLabel)

    local dropdown = CreateFrame("Frame", nil, row, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", -9, -22)
    UIDropDownMenu_SetWidth(dropdown, 150)

    UIDropDownMenu_Initialize(dropdown, function()
        for _, value in ipairs(fontValues) do
            local realValue = type(value) == "table" and value.value or value
            local textValue = type(value) == "table" and (value.label or InfoStrip:L(value.labelKey)) or fontLabelFunc(realValue)
            local info = UIDropDownMenu_CreateInfo()
            info.text = textValue
            info.checked = fontGetter() == realValue
            info.func = function()
                fontSetter(realValue)
                UIDropDownMenu_SetText(dropdown, textValue)
                CloseDropDownMenus()
                InfoStrip.Display:ApplySettings()
                Options:Refresh()
            end
            UIDropDownMenu_AddButton(info)
        end
    end)

    local swatch = CreateColorSwatch(row, colorLabel, 252, -26, colorGetter, nil)

    local bold = CreateFrame("CheckButton", nil, row, "SettingsCheckBoxTemplate")
    bold:SetPoint("TOPLEFT", row, "TOPLEFT", 440, -22)
    bold:SetSize(21, 20)
    local boldText = bold:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    boldText:SetPoint("LEFT", bold, "RIGHT", 4, 0)
    boldText:SetText(boldLabel)

    function row:Refresh()
        UIDropDownMenu_SetText(dropdown, fontLabelFunc(fontGetter()))
        bold:SetChecked(boldGetter() and true or false)
    end

    bold:SetScript("OnClick", function()
        boldSetter(bold:GetChecked())
        InfoStrip.Display:ApplySettings()
        Options:Refresh()
    end)

    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 4
    StyleOptionRow(row, fontLabel, InfoStrip:L("hintFont"))
    AttachRowHoverToChild(row, dropdown)
    AttachRowHoverToChild(row, swatch)
    AttachRowHoverToChild(row, bold)
    row:Refresh()
    Options:RegisterControl(row)
    return row
end

local function CreateColorSwatchGroupRow(parent, specs, shouldDisplay)
    return CreateColorSwatchRow(parent, specs, shouldDisplay, 34)
end

local function CreateEditBox(parent, label, getter, setter, width, rowHeight)
    local row = CreateFrame("Frame", nil, parent)
    local hasLabel = label and label ~= ""
    rowHeight = rowHeight or (hasLabel and 124 or 104)
    row:SetSize(CONTENT_WIDTH, rowHeight)

    local topOffset = -4
    if hasLabel then
        local labelText = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        labelText:SetPoint("TOPLEFT", 7, -3)
        labelText:SetText(label)
        topOffset = -28
    end

    local boxFrame = CreateFrame("Frame", nil, row, "BackdropTemplate")
    boxFrame:SetPoint("TOPLEFT", 7, topOffset)
    boxFrame:SetSize(width or INNER_WIDTH, rowHeight - (hasLabel and 42 or 22))
    boxFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 12,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    boxFrame:SetBackdropColor(0, 0, 0, 0.36)
    boxFrame:SetBackdropBorderColor(1, 1, 1, 0.22)

    local editBox = CreateFrame("EditBox", nil, boxFrame)
    editBox:SetPoint("TOPLEFT", boxFrame, "TOPLEFT", 8, -8)
    editBox:SetPoint("BOTTOMRIGHT", boxFrame, "BOTTOMRIGHT", -8, 8)
    editBox:SetAutoFocus(false)
    editBox:SetMultiLine(true)
    editBox:SetMaxLetters(0)
    editBox:SetJustifyH("LEFT")
    editBox:SetJustifyV("TOP")
    if editBox.SetFontObject and GameFontHighlightSmall then
        editBox:SetFontObject(GameFontHighlightSmall)
    end
    editBox:SetTextInsets(0, 0, 0, 0)

    function row:Refresh()
        if not editBox:HasFocus() then
            editBox:SetText(getter() or "")
            editBox:SetCursorPosition(0)
        end
    end

    local function Save()
        setter(editBox:GetText() or "")
        Options:UpdatePreview()
        InfoStrip.Display:ApplySettings()
        Options:Refresh()
    end

    editBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    editBox:SetScript("OnEditFocusLost", function()
        Save()
    end)
    editBox:SetScript("OnTextChanged", function()
        Options:UpdatePreview()
    end)

    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 5
    StyleOptionRow(row, hasLabel and label or InfoStrip:L("template"), InfoStrip:L("hintTemplate"))
    AttachRowHoverToChild(row, boxFrame)
    AttachRowHoverToChild(row, editBox)
    row:Refresh()
    Options:RegisterControl(row)
    return row, editBox
end

local function AppendTemplateText(text)
    if not Options.templateEditBox then
        return
    end

    local editBox = Options.templateEditBox
    local current = editBox:GetText() or ""
    local cursor = editBox:GetCursorPosition() or #current
    local before = current:sub(1, cursor)
    local after = current:sub(cursor + 1)
    local newText = before .. text .. after
    editBox:SetText(newText)
    editBox:SetCursorPosition(cursor + #text)
    Options:UpdatePreview()
end

local function AppendTemplateToken(token)
    AppendTemplateText("{%" .. token .. "}")
end

local function ApplyTemplateFromEditBox()
    if not Options.templateEditBox then
        return
    end

    InfoStripDB.general.template = Utils.NormalizeTemplateFormat(Options.templateEditBox:GetText() or "")
    Options.templateEditBox:SetText(InfoStripDB.general.template)
    Options.templateEditBox:SetCursorPosition(#InfoStripDB.general.template)
    Utils.SyncDisplayFromTemplate(InfoStripDB.general.template)
    InfoStrip.Display:ApplySettings()
    Options:Refresh()
end

local function MakeTokenButtonSpecs(list)
    local specs = {}
    for _, item in ipairs(list) do
        table.insert(specs, {
            label = InfoStrip:L(item.labelKey),
            width = 160,
            hint = InfoStrip:L("hintTokenButtons"),
            onClick = function() AppendTemplateToken(item.key) end,
        })
    end
    return specs
end

local function ThresholdUnit(kind)
    if kind == "fps" then
        return "FPS"
    elseif kind == "latency" then
        return "ms"
    elseif kind == "bandwidth" then
        return "KB/s"
    elseif kind == "speed" then
        return "%"
    end
    return nil
end

local function CreateThresholdNumberRows(parent, kind, group, cfg)
    local rows = {}
    local unit = ThresholdUnit(kind)
    local showThresholds = function()
        return InfoStripDB.ui.appearanceExpanded[kind] and cfg.mode == "thresholdCustom"
    end

    if cfg.thresholdDirection == "lowerIsWorse" then
        local warningLabel = kind == "speed" and InfoStrip:L("speedWarningBelow") or InfoStrip:L("fpsWarningBelow")
        local badLabel = kind == "speed" and InfoStrip:L("speedBadBelow") or InfoStrip:L("fpsBadBelow")
        local maxValue = kind == "speed" and 400 or 300

        local warningRow = CreateNumberRow(group, warningLabel, 1, maxValue, 1,
            function() return cfg.warningBelow end,
            function(value)
                cfg.warningBelow = value
                Utils.ValidateThresholdGroup(kind)
            end,
            showThresholds,
            unit
        )
        warningRow.ShouldDisplay = showThresholds
        table.insert(rows, warningRow)

        local badRow = CreateNumberRow(group, badLabel, 0, maxValue - 1, 1,
            function() return cfg.badBelow end,
            function(value)
                cfg.badBelow = value
                Utils.ValidateThresholdGroup(kind)
            end,
            showThresholds,
            unit
        )
        badRow.ShouldDisplay = showThresholds
        table.insert(rows, badRow)
    else
        local warningLabel = kind == "bandwidth" and InfoStrip:L("bandwidthWarningAbove") or InfoStrip:L("latencyWarningAbove")
        local badLabel = kind == "bandwidth" and InfoStrip:L("bandwidthBadAbove") or InfoStrip:L("latencyBadAbove")
        local maxValue = kind == "bandwidth" and 4096 or 2000

        local warningRow = CreateNumberRow(group, warningLabel, 1, maxValue, 1,
            function() return cfg.warningAbove end,
            function(value)
                cfg.warningAbove = value
                Utils.ValidateThresholdGroup(kind)
            end,
            showThresholds,
            unit
        )
        warningRow.ShouldDisplay = showThresholds
        table.insert(rows, warningRow)

        local badRow = CreateNumberRow(group, badLabel, 2, maxValue + 1, 1,
            function() return cfg.badAbove end,
            function(value)
                cfg.badAbove = value
                Utils.ValidateThresholdGroup(kind)
            end,
            showThresholds,
            unit
        )
        badRow.ShouldDisplay = showThresholds
        table.insert(rows, badRow)
    end

    return rows
end

local function CreateValueColorGroup(parent, kind, title, gateGetter)
    local group = CreateFrame("Frame", nil, parent)
    group:SetSize(CONTENT_WIDTH, 44)
    group.layoutIndex = parent:GetLayoutIndex()
    group.bottomPadding = 8

    local cfg = InfoStripDB.appearance.valueColors[kind]
    local groupLayoutIndex = 0
    function group:GetLayoutIndex()
        groupLayoutIndex = groupLayoutIndex + 1
        return groupLayoutIndex
    end

    local expandedDefault = gateGetter() and true or false
    if InfoStripDB.ui.appearanceExpanded[kind] == nil then
        InfoStripDB.ui.appearanceExpanded[kind] = expandedDefault
    end

    local header = CreateFrame("Button", nil, group, "UIPanelButtonTemplate")
    header:SetPoint("TOPLEFT", 7, -4)
    header:SetSize(28, 22)
    header:SetText("")

    local markerText = header:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    markerText:SetPoint("CENTER", header, "CENTER", 0, 0)

    local titleButton = CreateFrame("Button", nil, group)
    titleButton:SetPoint("LEFT", header, "RIGHT", 6, 0)
    titleButton:SetSize(CONTENT_WIDTH - 175, 22)

    local titleText = titleButton:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    titleText:SetPoint("LEFT", titleButton, "LEFT", 0, 0)
    titleText:SetJustifyH("LEFT")

    local resetButton = CreateFrame("Button", nil, group, "UIPanelButtonTemplate")
    resetButton:SetSize(72, 24)
    resetButton:SetPoint("TOPRIGHT", group, "TOPRIGHT", -8, -3)
    resetButton:SetText(InfoStrip:L("reset"))
    resetButton:SetScript("OnClick", function()
        Utils.ResetValueColor(kind)
        InfoStrip.Display:ApplySettings()
        Options:Refresh()
    end)
    resetButton:SetScript("OnEnter", function(self)
        ShowInfoTooltip(self, self:GetText(), InfoStrip:L("hintResetValueColorGroup"))
    end)
    resetButton:SetScript("OnLeave", HideInfoTooltip)

    local body = CreateFrame("Frame", nil, group, "BackdropTemplate")
    body:SetPoint("TOPLEFT", 0, -38)
    body:SetSize(CONTENT_WIDTH, 10)
    body:EnableMouse(false)
    body:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 12,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    body:SetBackdropColor(0, 0, 0, 0.52)
    body:SetBackdropBorderColor(1, 1, 1, 0.24)

    if body.SetFrameLevel and group.GetFrameLevel then
        body:SetFrameLevel(group:GetFrameLevel())
    end

    local function ToggleGroup()
        if not gateGetter() then
            return
        end
        InfoStripDB.ui.appearanceExpanded[kind] = not InfoStripDB.ui.appearanceExpanded[kind]
        Options:Refresh()
    end

    header:SetScript("OnClick", ToggleGroup)
    header:SetScript("OnEnter", function(self)
        if gateGetter() then
            ShowInfoTooltip(self, title, InfoStrip:L("clickToExpandCollapse"))
        end
    end)
    header:SetScript("OnLeave", HideInfoTooltip)
    titleButton:SetScript("OnClick", ToggleGroup)

    local modeValues = cfg.kind == "simple" and colorModesSimple or colorModesThreshold

    local modeRow = CreateDropdown(group, InfoStrip:L("colorMode"), modeValues,
        function(value) return ValueLabel(modeValues, value) end,
        function() return cfg.mode end,
        function(value)
            cfg.mode = value
            Utils.ValidateThresholdGroup(kind)
        end,
        function() return InfoStripDB.ui.appearanceExpanded[kind] end
    )
    modeRow:SetSize(INNER_WIDTH, 58)
    modeRow.bottomPadding = 8

    local fixedRow = CreateColorRow(group, InfoStrip:L("fixedColor"), function() return cfg.fixed end,
        function() return InfoStripDB.ui.appearanceExpanded[kind] and cfg.mode == "fixed" end
    )
    fixedRow.ShouldDisplay = function()
        return InfoStripDB.ui.appearanceExpanded[kind] and cfg.mode == "fixed"
    end

    if cfg.kind == "threshold" then
        CreateColorSwatchGroupRow(group, {
            {
                width = 180,
                label = InfoStrip:L("goodColor"),
                colorGetter = function() return cfg.good end,
                enabledGetter = function() return InfoStripDB.ui.appearanceExpanded[kind] and cfg.mode == "thresholdCustom" end,
            },
            {
                width = 180,
                label = InfoStrip:L("warningColor"),
                colorGetter = function() return cfg.warning end,
                enabledGetter = function() return InfoStripDB.ui.appearanceExpanded[kind] and cfg.mode == "thresholdCustom" end,
            },
            {
                width = 180,
                label = InfoStrip:L("badColor"),
                colorGetter = function() return cfg.bad end,
                enabledGetter = function() return InfoStripDB.ui.appearanceExpanded[kind] and cfg.mode == "thresholdCustom" end,
            },
        }, function()
            return InfoStripDB.ui.appearanceExpanded[kind] and cfg.mode == "thresholdCustom"
        end)

        CreateThresholdNumberRows(parent, kind, group, cfg)
    end

    function group:RefreshLayout()
        local enabled = gateGetter()
        local expanded = enabled and InfoStripDB.ui.appearanceExpanded[kind]
        markerText:SetText(expanded and "－" or "＋")
        titleText:SetText(title)
        if enabled then
            header:Enable()
            titleButton:Enable()
            resetButton:Enable()
            header:SetAlpha(1)
            titleButton:SetAlpha(1)
            resetButton:SetAlpha(1)
            markerText:SetFontObject("GameFontNormalHuge")
            titleText:SetFontObject("GameFontNormalLarge")
        else
            header:Disable()
            titleButton:Disable()
            resetButton:Disable()
            header:SetAlpha(0.72)
            titleButton:SetAlpha(0.72)
            resetButton:SetAlpha(0.45)
            markerText:SetFontObject("GameFontDisableLarge")
            titleText:SetFontObject("GameFontDisableLarge")
        end

        local children = { self:GetChildren() }
        table.sort(children, function(a, b)
            return (a.layoutIndex or 99999) < (b.layoutIndex or 99999)
        end)
        local y = -54
        local height = 44
        local bodyContentHeight = 0

        for _, child in ipairs(children) do
            if child ~= header and child ~= body and child.layoutIndex then
                local shouldDisplay = expanded
                if shouldDisplay and child.ShouldDisplay then
                    shouldDisplay = child:ShouldDisplay()
                end

                if shouldDisplay then
                    child:Show()
                    child:ClearAllPoints()
                    child:SetPoint("TOPLEFT", self, "TOPLEFT", 16, y)
                    if child.SetWidth then child:SetWidth(INNER_WIDTH) end
                    local childHeight = (child:GetHeight() or 28) + (child.bottomPadding or 4)
                    y = y - childHeight
                    height = height + childHeight
                    bodyContentHeight = bodyContentHeight + childHeight
                    child:SetAlpha(1)
                else
                    child:Hide()
                end
            end
        end

        if expanded then
            body:Show()
            body:SetHeight(math.max(bodyContentHeight + 34, 48))
            height = height + 20
        else
            body:Hide()
        end

        self:SetHeight(height)
    end

    function group:Refresh()
        self:RefreshLayout()
    end

    group:RefreshLayout()
    Options:RegisterControl(group)
    return group
end

local function CreatePreviewBlock(parent)
    CreateTextBlock(parent, InfoStrip:L("preview"), 26, "GameFontNormalLarge")

    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(CONTENT_WIDTH, 72)
    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 8
    StyleOptionRow(row, InfoStrip:L("preview"), InfoStrip:L("previewHint"))

    local previewFrame = CreateFrame("Frame", nil, row, "BackdropTemplate")
    previewFrame:SetPoint("TOPLEFT", row, "TOPLEFT", 7, 0)
    previewFrame:SetSize(CONTENT_WIDTH - 14, 72)
    previewFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    })
    previewFrame:SetBackdropColor(0, 0, 0, 0.36)
    previewFrame:SetBackdropBorderColor(1, 1, 1, 0.18)
    AttachRowHoverToChild(row, previewFrame)

    local previewText = previewFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    previewText:SetPoint("TOPLEFT", 10, -10)
    previewText:SetPoint("BOTTOMRIGHT", -10, 10)
    previewText:SetJustifyH("CENTER")
    previewText:SetJustifyV("MIDDLE")
    if previewText.SetSpacing then previewText:SetSpacing(4) end
    Options.previewText = previewText
    return row
end


Options.Private = {
    CONTENT_WIDTH = CONTENT_WIDTH,
    categoryIcon = categoryIcon,
    languages = languages,
    outlineModes = outlineModes,
    speedFormats = speedFormats,
    timeFormats = timeFormats,
    paddingModes = paddingModes,
    textAlignModes = textAlignModes,
    unavailableModes = unavailableModes,
    precisionValues = precisionValues,
    dateFormatPresets = dateFormatPresets,
    tokenButtonsFull = tokenButtonsFull,
    tokenButtonsValue = tokenButtonsValue,
    displayFieldItems = displayFieldItems,
    ValueLabel = ValueLabel,
    LanguageLabel = LanguageLabel,
    DateFormatPresetValue = DateFormatPresetValue,
    DateFormatPresetLabel = DateFormatPresetLabel,
    SetDateFormatPreset = SetDateFormatPreset,
    CreatePanel = CreatePanel,
    CreateDividerHeader = CreateDividerHeader,
    CreateSectionDivider = CreateSectionDivider,
    CreateTextBlock = CreateTextBlock,
    CreateSectionHeader = CreateSectionHeader,
    ResetTableSection = ResetTableSection,
    CreateBoxSubHeader = CreateBoxSubHeader,
    CreateIndentedContentBox = CreateIndentedContentBox,
    SetShouldDisplay = SetShouldDisplay,
    CreateCheck = CreateCheck,
    CreateDisplayFieldList = CreateDisplayFieldList,
    CreateButtonRow = CreateButtonRow,
    CreateDropdown = CreateDropdown,
    CreateFontColorBoldRow = CreateFontColorBoldRow,
    CreateNumberRow = CreateNumberRow,
    CreateColorRow = CreateColorRow,
    CreateValueColorGroup = CreateValueColorGroup,
    CreateEditBox = CreateEditBox,
    ApplyTemplateFromEditBox = ApplyTemplateFromEditBox,
    MakeTokenButtonSpecs = MakeTokenButtonSpecs,
    CreatePreviewBlock = CreatePreviewBlock,
}
