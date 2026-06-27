local InfoStrip = _G.InfoStrip

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

local function InitializeDatabase()
    InfoStripDB = InfoStripDB or {}
    InfoStrip.Utils.ApplyDefaults(InfoStripDB, InfoStrip.defaults)
end

local function PrintHelp()
    print("|cff00ff00InfoStrip commands:|r")
    print("/is lock")
    print("/is unlock")
    print("/is reset")
    print("/is options")
    print("/is lang auto")
    print("/is lang enUS")
    print("/is lang zhCN")
    print("/is lang zhTW")
end

local function RegisterSlashCommands()
    SLASH_INFOSTRIP1 = "/infostrip"
    SLASH_INFOSTRIP2 = "/is"

    SlashCmdList["INFOSTRIP"] = function(msg)
        msg = string.lower(msg or "")

        if msg == "lock" then
            InfoStripDB.position.locked = true
            InfoStrip.Display:ApplySettings()
            print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("lockedMsg"))

        elseif msg == "unlock" then
            InfoStripDB.position.locked = false
            InfoStrip.Display:ApplySettings()
            print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("unlockedMsg"))

        elseif msg == "reset" then
            InfoStrip.Display:ResetPosition()
            print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("resetMsg"))

        elseif msg == "options" or msg == "config" then
            InfoStrip.Options:Open()

        elseif msg == "lang auto" then
            InfoStripDB.language = "auto"
            ReloadUI()

        elseif msg == "lang enus" then
            InfoStripDB.language = "enUS"
            ReloadUI()

        elseif msg == "lang zhcn" then
            InfoStripDB.language = "zhCN"
            ReloadUI()

        elseif msg == "lang zhtw" then
            InfoStripDB.language = "zhTW"
            ReloadUI()

        else
            PrintHelp()
        end
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
