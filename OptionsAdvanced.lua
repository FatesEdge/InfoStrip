local InfoStrip = _G.InfoStrip
local Utils = InfoStrip.Utils
local Options = InfoStrip.Options
local P = Options.Private

local CONTENT_WIDTH = P.CONTENT_WIDTH
local tokenButtonsFull = P.tokenButtonsFull
local tokenButtonsValue = P.tokenButtonsValue
local CreatePanel = P.CreatePanel
local CreateDividerHeader = P.CreateDividerHeader
local CreateSectionDivider = P.CreateSectionDivider
local CreateTextBlock = P.CreateTextBlock
local CreateButtonRow = P.CreateButtonRow
local CreateEditBox = P.CreateEditBox
local ApplyTemplateFromEditBox = P.ApplyTemplateFromEditBox
local MakeTokenButtonSpecs = P.MakeTokenButtonSpecs
local CreatePreviewBlock = P.CreatePreviewBlock

local function BuildDebugInfo(template)
    local segments = Utils.ParseTemplate(template or "")
    local tokenNames = {}
    local tokenCount = 0
    for _, segment in ipairs(segments) do
        if segment.kind == "token" then
            tokenCount = tokenCount + 1
            table.insert(tokenNames, segment.value)
        end
    end

    local enabledCount = 0
    local enabledNames = {}
    for _, item in ipairs(P.displayFieldItems or {}) do
        if InfoStripDB.display[item.displayKey] then
            enabledCount = enabledCount + 1
            local enabledName = item.displayKey:gsub("^show", "")
            table.insert(enabledNames, enabledName)
        end
    end

    return table.concat({
        InfoStrip:L("debugSchema") .. " = " .. tostring(InfoStripDB.schemaVersion),
        InfoStrip:L("debugUpdateInterval") .. " = " .. tostring(InfoStripDB.general.updateIntervalMs),
        InfoStrip:L("debugTokenCount") .. " = " .. tostring(tokenCount) .. " [" .. table.concat(tokenNames, ", ") .. "]",
        InfoStrip:L("debugEnabledFields") .. " = " .. tostring(enabledCount) .. " [" .. table.concat(enabledNames, ", ") .. "]",
        InfoStrip:L("debugTemplate") .. " = " .. tostring(template),
    }, "\n")
end

function Options:UpdatePreview()
    if not self.previewText then
        return
    end

    local template = self.templateEditBox and self.templateEditBox:GetText() or InfoStripDB.general.template
    self.previewText:SetJustifyH(Utils.GetTextAlign())
    self.previewText:SetText(InfoStrip.Display:BuildPreviewText(template))

    if self.debugText then
        self.debugText:SetText(BuildDebugInfo(template))
    end
end

local function ResetTemplateFromEditBox()
    InfoStripDB.general.template = InfoStrip.defaults.general.template
    Utils.SyncDisplayFromTemplate(InfoStripDB.general.template)
    if Options.templateEditBox then
        Options.templateEditBox:SetText(InfoStripDB.general.template)
        Options.templateEditBox:SetCursorPosition(#InfoStripDB.general.template)
    end
    InfoStrip.Display:ApplySettings()
    Options:Refresh()
end

local function CreateTemplateHeader(parent)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(CONTENT_WIDTH, 34)

    local title = row:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("LEFT", 7, 0)
    title:SetWidth(CONTENT_WIDTH - 330)
    title:SetJustifyH("LEFT")
    title:SetText(InfoStrip:L("template"))

    local reset = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    reset:SetSize(150, 24)
    reset:SetPoint("RIGHT", row, "RIGHT", -170, 0)
    reset:SetText(InfoStrip:L("resetTemplate"))
    reset:SetScript("OnClick", ResetTemplateFromEditBox)

    local apply = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    apply:SetSize(150, 24)
    apply:SetPoint("RIGHT", row, "RIGHT", -12, 0)
    apply:SetText(InfoStrip:L("applyTemplate"))
    apply:SetScript("OnClick", ApplyTemplateFromEditBox)

    row.layoutIndex = parent:GetLayoutIndex()
    row.bottomPadding = 4
    return row
end

function Options:CreateAdvancedPanel()
    local panel = CreatePanel()
    self.advancedPanel = panel

    panel:SetScript("OnShow", function()
        if Options.templateEditBox and not Options.templateEditBox:HasFocus() then
            Options.templateEditBox:SetText(InfoStripDB.general.template or "")
            Options.templateEditBox:SetCursorPosition(0)
        end
        if panel.Layout then
            panel:Layout()
        end
        panel:UpdateScrollHeight()
        Options:UpdatePreview()
    end)

    CreateDividerHeader(panel, InfoStrip:L("advanced"), InfoStrip:L("advancedPageDescription"))
    CreatePreviewBlock(panel)
    CreateSectionDivider(panel)
    CreateTemplateHeader(panel)

    local _, editBox = CreateEditBox(panel, "",
        function() return InfoStripDB.general.template end,
        function(value)
            InfoStripDB.general.template = Utils.NormalizeTemplateFormat(value)
            Utils.SyncDisplayFromTemplate(InfoStripDB.general.template)
        end,
        CONTENT_WIDTH - 14,
        104
    )
    self.templateEditBox = editBox
    editBox:SetText(InfoStripDB.general.template or "")
    editBox:SetCursorPosition(0)

    CreateTextBlock(panel, InfoStrip:L("fullTokens"), 26, "GameFontNormal")
    CreateButtonRow(panel, MakeTokenButtonSpecs(tokenButtonsFull))

    CreateTextBlock(panel, InfoStrip:L("valueTokens"), 26, "GameFontNormal")
    CreateButtonRow(panel, MakeTokenButtonSpecs(tokenButtonsValue))


    CreateTextBlock(panel, InfoStrip:L("templateHint"), 86)


    CreateSectionDivider(panel)
    CreateTextBlock(panel, InfoStrip:L("debugInfo"), 26, "GameFontNormalLarge")
    local debugBlock = CreateTextBlock(panel, "", 96, "GameFontDisable")
    self.debugText = debugBlock.text

    panel:Layout()
    panel:UpdateScrollHeight()
    self:UpdatePreview()
    return panel.outerPanel or panel
end

