local InfoStrip = _G.InfoStrip
local Utils = InfoStrip.Utils
local Options = InfoStrip.Options
local P = Options.Private

local outlineModes = P.outlineModes
local speedFormats = P.speedFormats
local timeFormats = P.timeFormats
local paddingModes = P.paddingModes
local textAlignModes = P.textAlignModes
local unavailableModes = P.unavailableModes
local precisionValues = P.precisionValues
local dateFormatPresets = P.dateFormatPresets
local ValueLabel = P.ValueLabel
local DateFormatPresetValue = P.DateFormatPresetValue
local DateFormatPresetLabel = P.DateFormatPresetLabel
local SetDateFormatPreset = P.SetDateFormatPreset
local CreatePanel = P.CreatePanel
local CreateDividerHeader = P.CreateDividerHeader
local CreateSectionDivider = P.CreateSectionDivider
local CreateSectionHeader = P.CreateSectionHeader
local ResetTableSection = P.ResetTableSection
local CreateBoxSubHeader = P.CreateBoxSubHeader
local CreateIndentedContentBox = P.CreateIndentedContentBox
local SetShouldDisplay = P.SetShouldDisplay
local CreateCheck = P.CreateCheck
local CreateDropdown = P.CreateDropdown
local CreateFontColorBoldRow = P.CreateFontColorBoldRow
local CreateNumberRow = P.CreateNumberRow
local CreateColorRow = P.CreateColorRow
local CreateValueColorGroup = P.CreateValueColorGroup

function Options:CreateAppearancePanel()
    local panel = CreatePanel()
    self.appearancePanel = panel

    CreateDividerHeader(panel, InfoStrip:L("appearance"), InfoStrip:L("appearancePageDescription"))

    CreateSectionHeader(panel, InfoStrip:L("textSection"), InfoStrip:L("resetText"), function()
        ResetTableSection(InfoStripDB.appearance.text, InfoStrip.defaults.appearance.text)
    end, InfoStrip:L("hintResetText"))

    CreateFontColorBoldRow(panel,
        InfoStrip:L("font"),
        InfoStrip:L("mainTextColor"),
        InfoStrip:L("bold"),
        Utils.GetFontOptions(),
        function(value)
            value = Utils.NormalizeFontValue(value)
            for _, option in ipairs(Utils.GetFontOptions()) do
                if option.value == value then
                    return option.label or value
                end
            end
            return value
        end,
        function() return Utils.NormalizeFontValue(InfoStripDB.appearance.text.fontFamily) end,
        function(value) InfoStripDB.appearance.text.fontFamily = Utils.NormalizeFontValue(value) end,
        function() return InfoStripDB.appearance.text.mainColor end,
        function() return InfoStripDB.appearance.text.bold end,
        function(value) InfoStripDB.appearance.text.bold = value end
    )

    CreateNumberRow(panel, InfoStrip:L("fontSize"), 8, 32, 1,
        function() return InfoStripDB.appearance.text.fontSize end,
        function(value) InfoStripDB.appearance.text.fontSize = value end
    )

    CreateDropdown(panel, InfoStrip:L("outline"), outlineModes,
        function(value) return ValueLabel(outlineModes, value) end,
        function() return InfoStripDB.appearance.text.outline end,
        function(value) InfoStripDB.appearance.text.outline = value end
    )

    CreateCheck(panel, InfoStrip:L("shadow"),
        function() return InfoStripDB.appearance.text.shadow end,
        function(value) InfoStripDB.appearance.text.shadow = value end
    )

    local shadowBox = CreateIndentedContentBox(panel)
    SetShouldDisplay(shadowBox, function() return InfoStripDB.appearance.text.shadow end)

    CreateNumberRow(shadowBox, InfoStrip:L("shadowAlpha"), 0, 1, 0.05,
        function() return InfoStripDB.appearance.text.shadowAlpha end,
        function(value) InfoStripDB.appearance.text.shadowAlpha = value end,
        nil,
        "alpha"
    )

    CreateNumberRow(shadowBox, InfoStrip:L("shadowOffsetX"), -6, 6, 1,
        function() return InfoStripDB.appearance.text.shadowOffsetX end,
        function(value) InfoStripDB.appearance.text.shadowOffsetX = value end,
        nil,
        "px"
    )

    CreateNumberRow(shadowBox, InfoStrip:L("shadowOffsetY"), -6, 6, 1,
        function() return InfoStripDB.appearance.text.shadowOffsetY end,
        function(value) InfoStripDB.appearance.text.shadowOffsetY = value end,
        nil,
        "px"
    )

    CreateSectionDivider(panel)
    CreateSectionHeader(panel, InfoStrip:L("formatSection"), InfoStrip:L("resetFormat"), function()
        ResetTableSection(InfoStripDB.appearance.format, InfoStrip.defaults.appearance.format)
    end, InfoStrip:L("hintResetFormat"))

    CreateDropdown(panel, InfoStrip:L("dateFormat"), dateFormatPresets,
        DateFormatPresetLabel,
        DateFormatPresetValue,
        SetDateFormatPreset,
        function() return InfoStripDB.display.showDate end
    )

    CreateDropdown(panel, InfoStrip:L("timeFormat"), timeFormats,
        function(value) return ValueLabel(timeFormats, value) end,
        function() return InfoStripDB.appearance.format.timeFormat end,
        function(value) InfoStripDB.appearance.format.timeFormat = value end,
        function() return InfoStripDB.display.showLocalTime or InfoStripDB.display.showServerTime end
    )

    CreateCheck(panel, InfoStrip:L("showSeconds"),
        function() return InfoStripDB.appearance.format.showSeconds end,
        function(value) InfoStripDB.appearance.format.showSeconds = value end,
        function() return InfoStripDB.display.showLocalTime or InfoStripDB.display.showServerTime end
    )

    CreateDropdown(panel, InfoStrip:L("speedFormat"), speedFormats,
        function(value) return ValueLabel(speedFormats, value) end,
        function() return InfoStripDB.appearance.format.speedFormat end,
        function(value) InfoStripDB.appearance.format.speedFormat = value end,
        function() return InfoStripDB.display.showSpeed end
    )

    CreateDropdown(panel, InfoStrip:L("unavailableMode"), unavailableModes,
        function(value) return ValueLabel(unavailableModes, value) end,
        function() return InfoStripDB.appearance.format.coordUnavailableMode end,
        function(value) InfoStripDB.appearance.format.coordUnavailableMode = value end,
        function() return InfoStripDB.display.showCoord end
    )

    CreateDropdown(panel, InfoStrip:L("coordPrecision"), precisionValues,
        function(value) return tostring(value or 0) end,
        function() return InfoStripDB.appearance.format.coordPrecision end,
        function(value) InfoStripDB.appearance.format.coordPrecision = tonumber(value) or 1 end,
        function() return InfoStripDB.display.showCoord end
    )

    CreateSectionDivider(panel)
    CreateSectionHeader(panel, InfoStrip:L("frameSection"), InfoStrip:L("resetFrame"), function()
        ResetTableSection(InfoStripDB.appearance.frame, InfoStrip.defaults.appearance.frame)
    end, InfoStrip:L("hintResetFrame"))

    CreateCheck(panel, InfoStrip:L("background"),
        function() return InfoStripDB.appearance.frame.backgroundEnabled end,
        function(value) InfoStripDB.appearance.frame.backgroundEnabled = value end
    )
    local backgroundBox = CreateIndentedContentBox(panel)
    SetShouldDisplay(backgroundBox, function() return InfoStripDB.appearance.frame.backgroundEnabled end)
    backgroundBox:Refresh()
    CreateColorRow(backgroundBox, InfoStrip:L("backgroundColor"),
        function() return InfoStripDB.appearance.frame.backgroundColor end,
        function() return InfoStripDB.appearance.frame.backgroundEnabled end
    )
    CreateNumberRow(backgroundBox, InfoStrip:L("backgroundAlpha"), 0, 1, 0.05,
        function() return InfoStripDB.appearance.frame.backgroundColor.a end,
        function(value) InfoStripDB.appearance.frame.backgroundColor.a = value end,
        function() return InfoStripDB.appearance.frame.backgroundEnabled end,
        "alpha"
    )

    CreateCheck(panel, InfoStrip:L("border"),
        function() return InfoStripDB.appearance.frame.borderEnabled end,
        function(value) InfoStripDB.appearance.frame.borderEnabled = value end
    )
    local borderBox = CreateIndentedContentBox(panel)
    SetShouldDisplay(borderBox, function() return InfoStripDB.appearance.frame.borderEnabled end)
    borderBox:Refresh()
    CreateColorRow(borderBox, InfoStrip:L("borderColor"),
        function() return InfoStripDB.appearance.frame.borderColor end,
        function() return InfoStripDB.appearance.frame.borderEnabled end
    )
    CreateNumberRow(borderBox, InfoStrip:L("borderAlpha"), 0, 1, 0.05,
        function() return InfoStripDB.appearance.frame.borderColor.a end,
        function(value) InfoStripDB.appearance.frame.borderColor.a = value end,
        function() return InfoStripDB.appearance.frame.borderEnabled end,
        "alpha"
    )
    CreateNumberRow(borderBox, InfoStrip:L("borderSize"), 1, 6, 1,
        function() return InfoStripDB.appearance.frame.borderSize end,
        function(value) InfoStripDB.appearance.frame.borderSize = value end,
        function() return InfoStripDB.appearance.frame.borderEnabled end,
        "px"
    )

    CreateBoxSubHeader(panel, InfoStrip:L("layout"))
    local layoutBox = CreateIndentedContentBox(panel)
    CreateNumberRow(layoutBox, InfoStrip:L("lineSpacing"), 1.0, 2.0, 0.05,
        function() return InfoStripDB.appearance.frame.lineSpacingMultiplier end,
        function(value) InfoStripDB.appearance.frame.lineSpacingMultiplier = value end,
        nil,
        "x"
    )

    CreateDropdown(layoutBox, InfoStrip:L("textAlign"), textAlignModes,
        function(value) return ValueLabel(textAlignModes, value) end,
        function() return Utils.GetTextAlign() end,
        function(value) InfoStripDB.appearance.frame.textAlign = value end
    )

    local cornerRadiusRow = CreateNumberRow(layoutBox, InfoStrip:L("cornerRadius"), 0, 18, 1,
        function() return InfoStripDB.appearance.frame.cornerRadius end,
        function(value) InfoStripDB.appearance.frame.cornerRadius = value end,
        function() return InfoStripDB.appearance.frame.backgroundEnabled or InfoStripDB.appearance.frame.borderEnabled end,
        "px"
    )
    SetShouldDisplay(cornerRadiusRow, function() return InfoStripDB.appearance.frame.backgroundEnabled or InfoStripDB.appearance.frame.borderEnabled end)

    CreateDropdown(layoutBox, InfoStrip:L("paddingMode"), paddingModes,
        function(value) return ValueLabel(paddingModes, value) end,
        function() return InfoStripDB.appearance.frame.paddingMode end,
        function(value) InfoStripDB.appearance.frame.paddingMode = value end
    )
    local paddingRow = CreateNumberRow(layoutBox, InfoStrip:L("padding"), 0, 40, 1,
        function() return InfoStripDB.appearance.frame.padding end,
        function(value) InfoStripDB.appearance.frame.padding = value end,
        function() return InfoStripDB.appearance.frame.paddingMode == "uniform" end,
        "px"
    )
    SetShouldDisplay(paddingRow, function() return InfoStripDB.appearance.frame.paddingMode == "uniform" end)

    local paddingXRow = CreateNumberRow(layoutBox, InfoStrip:L("paddingX"), 0, 60, 1,
        function() return InfoStripDB.appearance.frame.paddingX end,
        function(value) InfoStripDB.appearance.frame.paddingX = value end,
        function() return InfoStripDB.appearance.frame.paddingMode == "xy" end,
        "px"
    )
    SetShouldDisplay(paddingXRow, function() return InfoStripDB.appearance.frame.paddingMode == "xy" end)

    local paddingYRow = CreateNumberRow(layoutBox, InfoStrip:L("paddingY"), 0, 40, 1,
        function() return InfoStripDB.appearance.frame.paddingY end,
        function(value) InfoStripDB.appearance.frame.paddingY = value end,
        function() return InfoStripDB.appearance.frame.paddingMode == "xy" end,
        "px"
    )
    SetShouldDisplay(paddingYRow, function() return InfoStripDB.appearance.frame.paddingMode == "xy" end)
    backgroundBox:Refresh()
    borderBox:Refresh()
    layoutBox:RefreshLayout()


    CreateSectionDivider(panel)
    CreateSectionHeader(panel, InfoStrip:L("valueColorsSection"), InfoStrip:L("resetAllColors"), function()
        Utils.ResetValueColor("fps")
        Utils.ResetValueColor("latency")
        Utils.ResetValueColor("bandwidth")
        Utils.ResetValueColor("speed")
        Utils.ResetValueColor("coord")
        Utils.ResetValueColor("date")
        Utils.ResetValueColor("time")
    end, InfoStrip:L("hintResetValueColors"))

    CreateValueColorGroup(panel, "fps", InfoStrip:L("fpsColor"), function() return InfoStripDB.display.showFPS end)
    CreateValueColorGroup(panel, "latency", InfoStrip:L("latencyColor"), function() return InfoStripDB.display.showHomeLatency or InfoStripDB.display.showWorldLatency end)
    CreateValueColorGroup(panel, "bandwidth", InfoStrip:L("bandwidthColor"), function() return InfoStripDB.display.showBandwidthIn or InfoStripDB.display.showBandwidthOut end)
    CreateValueColorGroup(panel, "speed", InfoStrip:L("speedColor"), function() return InfoStripDB.display.showSpeed end)
    CreateValueColorGroup(panel, "coord", InfoStrip:L("coordColor"), function() return InfoStripDB.display.showCoord end)
    CreateValueColorGroup(panel, "date", InfoStrip:L("dateColor"), function() return InfoStripDB.display.showDate end)
    CreateValueColorGroup(panel, "time", InfoStrip:L("timeColor"), function() return InfoStripDB.display.showLocalTime or InfoStripDB.display.showServerTime end)


    panel:Layout()
    panel:UpdateScrollHeight()
    return panel.outerPanel or panel
end

