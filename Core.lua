local InfoStrip = _G.InfoStrip
local Utils = InfoStrip.Utils

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

local function InitializeDatabase()
    if type(InfoStripDB) ~= "table" or InfoStripDB.schemaVersion ~= InfoStrip.defaults.schemaVersion then
        InfoStripDB = {}
    end

    Utils.ApplyDefaults(InfoStripDB, InfoStrip.defaults)
    InfoStripDB.schemaVersion = InfoStrip.defaults.schemaVersion
    InfoStripDB.appearance.text.fontFamily = Utils.NormalizeFontValue(InfoStripDB.appearance.text.fontFamily)
    Utils.ValidateAllThresholds()
    Utils.SyncDisplayFromTemplate(InfoStripDB.general.template)
end

local function PrintHelp()
    print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("slashHelpTitle"))
    print("/is lock")
    print("/is unlock")
    print("/is reset")
    print("/is options")
    print("/is lang auto")
    print("/is lang enUS")
    print("/is lang zhCN")
    print("/is lang zhTW")
    print("/is lang deDE")
    print("/is lang esES")
    print("/is lang jaJP")
    print("/is lang koKR")
end

local slashLanguages = {
    ["lang auto"] = "auto",
    ["lang enus"] = "enUS",
    ["lang zhcn"] = "zhCN",
    ["lang zhtw"] = "zhTW",
    ["lang dede"] = "deDE",
    ["lang eses"] = "esES",
    ["lang jajp"] = "jaJP",
    ["lang kokr"] = "koKR",
}

local function RegisterSlashCommands()
    SLASH_INFOSTRIP1 = "/infostrip"
    SLASH_INFOSTRIP2 = "/is"

    SlashCmdList["INFOSTRIP"] = function(msg)
        msg = string.lower(msg or "")
        local slashLanguage = slashLanguages[msg]

        if msg == "lock" then
            InfoStripDB.position.locked = true
            InfoStrip.Display:ApplySettings()
            InfoStrip.Options:Refresh()
            print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("lockedMsg"))

        elseif msg == "unlock" then
            InfoStripDB.position.locked = false
            InfoStrip.Display:ApplySettings()
            InfoStrip.Options:Refresh()
            print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("unlockedMsg"))

        elseif msg == "reset" then
            InfoStrip.Display:ResetPosition()
            InfoStrip.Options:Refresh()
            print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("resetMsg"))

        elseif msg == "options" or msg == "config" then
            InfoStrip.Options:Open()

        elseif slashLanguage then
            InfoStripDB.language = slashLanguage
            ReloadUI()

        else
            PrintHelp()
        end
    end
end

function InfoStrip_OpenOptions()
    if InfoStrip and InfoStrip.Options then
        InfoStrip.Options:Open()
    end
end

function InfoStrip_OnAddonCompartmentEnter(button)
    if not GameTooltip then
        return
    end

    GameTooltip:SetOwner(button, "ANCHOR_LEFT")
    GameTooltip:SetText("InfoStrip")
    GameTooltip:AddLine(InfoStrip and InfoStrip:L("addonCompartmentHint") or "Left-click to open options.", 1, 1, 1)
    GameTooltip:Show()
end

function InfoStrip_OnAddonCompartmentLeave()
    if GameTooltip then
        GameTooltip:Hide()
    end
end

eventFrame:SetScript("OnEvent", function(_, event, addonName)
    if event ~= "ADDON_LOADED" or addonName ~= InfoStrip.addonName then
        return
    end

    InitializeDatabase()
    InfoStrip.Display:Initialize()
    InfoStrip.Options:Register()
    RegisterSlashCommands()

    print("|cff00ff00InfoStrip|r " .. InfoStrip:L("loaded"))
end)
