local InfoStrip = _G.InfoStrip

InfoStrip.Options = {}

local Options = InfoStrip.Options

local function CreateTitle(parent, text, x, y)
    local title = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", x or 16, y or -16)
    title:SetText(text)
    return title
end

local function CreateText(parent, text, x, y, width)
    local fs = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    fs:SetPoint("TOPLEFT", x or 16, y or -48)
    fs:SetWidth(width or 620)
    fs:SetJustifyH("LEFT")
    fs:SetText(text)
    return fs
end

local function CreateCheck(parent, label, x, y, getter, setter)
    local check = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    check:SetPoint("TOPLEFT", x, y)
    check:SetChecked(getter())

    check.label = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    check.label:SetPoint("LEFT", check, "RIGHT", 2, 0)
    check.label:SetText(label)

    check:SetScript("OnClick", function(self)
        setter(self:GetChecked())
        InfoStrip.Display:ApplySettings()
    end)

    return check
end

local function CreateButton(parent, label, x, y, width, onClick)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", x, y)
    button:SetSize(width or 140, 24)
    button:SetText(label)
    button:SetScript("OnClick", onClick)
    return button
end

local function CreateSlider(parent, label, x, y, minValue, maxValue, step, getter, setter)
    local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", x, y)
    slider:SetWidth(220)
    slider:SetMinMaxValues(minValue, maxValue)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    slider:SetValue(getter())

    slider.label = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    slider.label:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, 4)
    slider.label:SetText(label .. ": " .. getter())

    slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value / step) + 0.5) * step
        value = tonumber(string.format("%.2f", value))
        setter(value)
        self.label:SetText(label .. ": " .. value)
        InfoStrip.Display:ApplySettings()
    end)

    return slider
end

local function CreateEditBox(parent, label, x, y, width, getter, setter)
    local labelText = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    labelText:SetPoint("TOPLEFT", x, y)
    labelText:SetText(label)

    local editBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    editBox:SetPoint("TOPLEFT", x, y - 24)
    editBox:SetSize(width or 520, 24)
    editBox:SetAutoFocus(false)
    editBox:SetText(getter())

    editBox:SetScript("OnEnterPressed", function(self)
        setter(self:GetText())
        self:ClearFocus()
        InfoStrip.Display:ApplySettings()
    end)

    editBox:SetScript("OnEscapePressed", function(self)
        self:SetText(getter())
        self:ClearFocus()
    end)

    return editBox
end

function Options:CreateAboutPanel()
    local panel = CreateFrame("Frame", "InfoStripOptionsAboutPanel")

    CreateTitle(panel, "InfoStrip", 16, -16)
    CreateText(panel, InfoStrip:L("description"), 16, -48)
    CreateText(panel, InfoStrip:L("author") .. ": PanZK", 16, -78)
    CreateText(panel, InfoStrip:L("github") .. ": https://github.com/PanZK/InfoStrip", 16, -108)
    CreateText(panel, InfoStrip:L("version") .. ": " .. InfoStrip.version, 16, -138)

    CreateButton(panel, InfoStrip:L("resetPosition"), 16, -180, 140, function()
        InfoStrip.Display:ResetPosition()
        print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("resetMsg"))
    end)

    return panel
end

function Options:CreateGeneralPanel()
    local panel = CreateFrame("Frame", "InfoStripOptionsGeneralPanel")

    CreateTitle(panel, InfoStrip:L("general"), 16, -16)

    CreateText(panel, InfoStrip:L("position"), 16, -52)
    CreateCheck(panel, InfoStrip:L("locked"), 16, -78,
        function() return InfoStripDB.position.locked end,
        function(value) InfoStripDB.position.locked = value end
    )

    CreateButton(panel, InfoStrip:L("resetPosition"), 16, -116, 140, function()
        InfoStrip.Display:ResetPosition()
        print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("resetMsg"))
    end)

    CreateText(panel, InfoStrip:L("unlockHint"), 170, -118, 520)

    CreateSlider(panel, InfoStrip:L("updateInterval"), 16, -180, 0.2, 2.0, 0.1,
        function() return InfoStripDB.general.updateInterval end,
        function(value) InfoStripDB.general.updateInterval = value end
    )

    CreateText(panel, InfoStrip:L("display"), 16, -240)

    CreateCheck(panel, InfoStrip:L("showFPS"), 16, -266,
        function() return InfoStripDB.display.showFPS end,
        function(value) InfoStripDB.display.showFPS = value end
    )

    CreateCheck(panel, InfoStrip:L("showHomeLatency"), 16, -296,
        function() return InfoStripDB.display.showHomeLatency end,
        function(value) InfoStripDB.display.showHomeLatency = value end
    )

    CreateCheck(panel, InfoStrip:L("showWorldLatency"), 16, -326,
        function() return InfoStripDB.display.showWorldLatency end,
        function(value) InfoStripDB.display.showWorldLatency = value end
    )

    CreateCheck(panel, InfoStrip:L("showLocalTime"), 16, -356,
        function() return InfoStripDB.display.showLocalTime end,
        function(value) InfoStripDB.display.showLocalTime = value end
    )

    CreateCheck(panel, InfoStrip:L("showServerTime"), 16, -386,
        function() return InfoStripDB.display.showServerTime end,
        function(value) InfoStripDB.display.showServerTime = value end
    )

    CreateEditBox(panel, InfoStrip:L("template"), 16, -436, 600,
        function() return InfoStripDB.general.template end,
        function(value) InfoStripDB.general.template = value end
    )

    CreateText(panel, InfoStrip:L("templateHint"), 16, -490, 680)

    return panel
end

function Options:CreateColorsPanel()
    local panel = CreateFrame("Frame", "InfoStripOptionsColorsPanel")

    CreateTitle(panel, InfoStrip:L("colors"), 16, -16)

    CreateText(panel,
        "Current version uses default colors:\n\n" ..
        "FPS / latency value colors use green, yellow and red thresholds.\n" ..
        "Labels and units follow the main text color.\n\n" ..
        "Next step: add color picker buttons and color mode controls.",
        16,
        -52,
        680
    )

    return panel
end

function Options:CreateLanguagePanel()
    local panel = CreateFrame("Frame", "InfoStripOptionsLanguagePanel")

    CreateTitle(panel, InfoStrip:L("language"), 16, -16)

    CreateText(panel,
        "Current language mode: " .. tostring(InfoStripDB and InfoStripDB.language or "auto") .. "\n\n" ..
        "Supported language tables in this version:\n" ..
        "- auto\n" ..
        "- enUS\n" ..
        "- zhCN\n" ..
        "- zhTW\n\n" ..
        "For now, use slash command:\n" ..
        "/is lang auto\n" ..
        "/is lang enUS\n" ..
        "/is lang zhCN\n" ..
        "/is lang zhTW",
        16,
        -52,
        680
    )

    return panel
end

function Options:CreateAdvancedPanel()
    local panel = CreateFrame("Frame", "InfoStripOptionsAdvancedPanel")

    CreateTitle(panel, InfoStrip:L("advanced"), 16, -16)

    CreateText(panel,
        "Advanced options will be added later.\n\n" ..
        "Planned:\n" ..
        "- AddOn memory display\n" ..
        "- CPU profiling debug mode\n" ..
        "- Bandwidth display\n" ..
        "- Realm / region display",
        16,
        -52,
        680
    )

    return panel
end

function Options:Register()
    if not Settings or not Settings.RegisterCanvasLayoutCategory then
        print("|cffff0000InfoStrip:|r " .. InfoStrip:L("optionsUnavailable"))
        return
    end

    local aboutPanel = self:CreateAboutPanel()
    local generalPanel = self:CreateGeneralPanel()
    local colorsPanel = self:CreateColorsPanel()
    local languagePanel = self:CreateLanguagePanel()
    local advancedPanel = self:CreateAdvancedPanel()

    local category = Settings.RegisterCanvasLayoutCategory(aboutPanel, "InfoStrip")
    Settings.RegisterAddOnCategory(category)

    local generalCategory = Settings.RegisterCanvasLayoutSubcategory(category, generalPanel, InfoStrip:L("general"))
    local colorsCategory = Settings.RegisterCanvasLayoutSubcategory(category, colorsPanel, InfoStrip:L("colors"))
    local languageCategory = Settings.RegisterCanvasLayoutSubcategory(category, languagePanel, InfoStrip:L("language"))
    local advancedCategory = Settings.RegisterCanvasLayoutSubcategory(category, advancedPanel, InfoStrip:L("advanced"))

    self.category = category
    self.categoryID = category.ID

    self.generalCategory = generalCategory
    self.colorsCategory = colorsCategory
    self.languageCategory = languageCategory
    self.advancedCategory = advancedCategory
end

function Options:Open()
    if Settings and self.categoryID then
        Settings.OpenToCategory(self.categoryID)
        print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("optionsOpened"))
    else
        print("|cffff0000InfoStrip:|r " .. InfoStrip:L("optionsUnavailable"))
    end
end
