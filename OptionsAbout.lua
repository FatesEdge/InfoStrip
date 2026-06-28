local InfoStrip = _G.InfoStrip
local Options = InfoStrip.Options
local P = Options.Private

local CreatePanel = P.CreatePanel
local CreateDividerHeader = P.CreateDividerHeader
local CreateTextBlock = P.CreateTextBlock
local CreateSectionDivider = P.CreateSectionDivider

function Options:CreateAboutPanel()
    local panel = CreatePanel()
    self.aboutPanel = panel

    CreateDividerHeader(panel, "InfoStrip", InfoStrip:L("description"))
    CreateTextBlock(panel, InfoStrip:L("aboutSummary"), 36)
    CreateTextBlock(panel, InfoStrip:L("aboutAccess"), 52)
    CreateTextBlock(panel, InfoStrip:L("aboutNoLibraries"), 36)
    CreateTextBlock(panel, InfoStrip:L("aboutLanguages"), 46)
    CreateSectionDivider(panel)
    CreateTextBlock(panel, InfoStrip:L("version") .. ": " .. tostring(InfoStrip.version), 28)
    CreateTextBlock(panel, InfoStrip:L("author") .. ": " .. tostring(InfoStrip.authorName or "Fate's Edge"), 28)
    CreateTextBlock(panel, InfoStrip:L("github") .. ": " .. tostring(InfoStrip.githubUrl or "https://github.com/FatesEdge/InfoStrip"), 28)

    panel:Layout()
    panel:UpdateScrollHeight()
    return panel.outerPanel or panel
end

