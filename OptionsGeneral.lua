local InfoStrip = _G.InfoStrip
local Utils = InfoStrip.Utils
local Options = InfoStrip.Options
local P = Options.Private

local languages = P.languages
local LanguageLabel = P.LanguageLabel
local CreatePanel = P.CreatePanel
local CreateDividerHeader = P.CreateDividerHeader
local CreateSectionDivider = P.CreateSectionDivider
local CreateTextBlock = P.CreateTextBlock
local CreateSectionHeader = P.CreateSectionHeader
local ResetTableSection = P.ResetTableSection
local CreateCheck = P.CreateCheck
local CreateDisplayFieldList = P.CreateDisplayFieldList
local CreateButtonRow = P.CreateButtonRow
local CreateDropdown = P.CreateDropdown
local CreateNumberRow = P.CreateNumberRow

local function ApplyDisplayTemplate(template)
    InfoStripDB.general.template = template
    Utils.SyncDisplayFromTemplate(InfoStripDB.general.template)
    InfoStrip.Display:ApplySettings()
    Options:Refresh()
end

function Options:CreateGeneralPanel()
    local panel = CreatePanel()
    self.generalPanel = panel

    CreateDividerHeader(panel, InfoStrip:L("general"), InfoStrip:L("generalPageDescription"))

    CreateCheck(panel, InfoStrip:L("enabled"),
        function() return InfoStripDB.enabled end,
        function(value) InfoStripDB.enabled = value end
    )

    CreateCheck(panel, InfoStrip:L("showSettingsIcon"),
        function() return InfoStripDB.general.showSettingsIcon end,
        function(value) InfoStripDB.general.showSettingsIcon = value end
    )

    local languageRow = CreateDropdown(panel, InfoStrip:L("language"), languages, LanguageLabel,
        function() return InfoStripDB.language end,
        function(value)
            InfoStripDB.language = value
            ReloadUI()
        end
    )
    languageRow.tooltipHint = InfoStrip:L("languageReloadHint")

    CreateSectionDivider(panel)
    CreateSectionHeader(panel, InfoStrip:L("position"), InfoStrip:L("resetPosition"), function()
        InfoStrip.Display:ResetPosition()
        print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("resetMsg"))
    end, InfoStrip:L("hintResetPosition"))

    CreateCheck(panel, InfoStrip:L("locked"),
        function() return InfoStripDB.position.locked end,
        function(value) InfoStripDB.position.locked = value end
    )

    CreateTextBlock(panel, InfoStrip:L("unlockHint"), 28)

    CreateSectionDivider(panel)

    CreateNumberRow(panel, InfoStrip:L("updateIntervalMs"), 50, 2000, 50,
        function() return InfoStripDB.general.updateIntervalMs end,
        function(value) InfoStripDB.general.updateIntervalMs = value end,
        nil,
        "ms"
    )

    CreateSectionDivider(panel)
    CreateSectionHeader(panel, InfoStrip:L("display"), InfoStrip:L("resetDisplay"), function()
        ResetTableSection(InfoStripDB.display, InfoStrip.defaults.display)
        InfoStripDB.general.labels = {}
        Utils.ApplyDefaults(InfoStripDB.general.labels, InfoStrip.defaults.general.labels)
        InfoStripDB.general.template = InfoStrip.defaults.general.template
    end, InfoStrip:L("hintResetDisplay"))
    CreateTextBlock(panel, InfoStrip:L("displayFieldsHint"), 44)
    CreateDisplayFieldList(panel)

    CreateSectionDivider(panel)
    CreateSectionHeader(panel, InfoStrip:L("coordOptions"), InfoStrip:L("resetCoordinates"), function()
        ResetTableSection(InfoStripDB.coordinates, InfoStrip.defaults.coordinates)
    end, InfoStrip:L("hintResetCoordinates"))

    CreateCheck(panel, InfoStrip:L("outdoorOnly"),
        function() return InfoStripDB.coordinates.outdoorOnly end,
        function(value) InfoStripDB.coordinates.outdoorOnly = value end,
        function() return InfoStripDB.display.showCoord end
    )
    CreateCheck(panel, InfoStrip:L("hideInCombat"),
        function() return InfoStripDB.coordinates.hideInCombat end,
        function(value) InfoStripDB.coordinates.hideInCombat = value end,
        function() return InfoStripDB.display.showCoord end
    )
    CreateCheck(panel, InfoStrip:L("hideInInstance"),
        function() return InfoStripDB.coordinates.hideInInstance end,
        function(value) InfoStripDB.coordinates.hideInInstance = value end,
        function() return InfoStripDB.display.showCoord end
    )

    CreateSectionDivider(panel)
    CreateTextBlock(panel, InfoStrip:L("displayPresets"), 28, "GameFontNormalLarge")
    CreateTextBlock(panel, InfoStrip:L("displayPresetsHint"), 42)
    CreateButtonRow(panel, {
        {
            label = InfoStrip:L("presetCompact"),
            width = 110,
            onClick = function()
                ApplyDisplayTemplate("{%fps}  {%home}  {%world}")
            end,
        },
        {
            label = InfoStrip:L("presetFull"),
            width = 110,
            onClick = function()
                ApplyDisplayTemplate("{%fps}  {%home}  {%world}  {%total}  {%bw_in}  {%bw_out}  {%speed}  {%coord}  {%date}  {%local}  {%server}")
            end,
        },
        {
            label = InfoStrip:L("presetTwoLines"),
            width = 110,
            onClick = function()
                ApplyDisplayTemplate("{%fps}  {%home}  {%world}  {%total}\\n{%bw_in}  {%bw_out}  {%speed}  {%coord}  {%date}  {%local}  {%server}")
            end,
        },
        {
            label = InfoStrip:L("presetNetwork"),
            width = 110,
            onClick = function()
                ApplyDisplayTemplate("{%fps}  {%home}  {%world}  {%total}  {%bw_in}  {%bw_out}")
            end,
        },
    })

    panel:Layout()
    panel:UpdateScrollHeight()
    return panel.outerPanel or panel
end

