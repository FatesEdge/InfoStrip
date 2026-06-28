local InfoStrip = _G.InfoStrip
local Options = InfoStrip.Options
local P = Options.Private

local categoryIcon = P.categoryIcon

function Options:Register()
    if not Settings or not Settings.RegisterCanvasLayoutCategory then
        print("|cffff0000InfoStrip:|r " .. InfoStrip:L("optionsUnavailable"))
        return
    end

    local aboutPanel = self:CreateAboutPanel()
    local generalPanel = self:CreateGeneralPanel()
    local appearancePanel = self:CreateAppearancePanel()
    local advancedPanel = self:CreateAdvancedPanel()

    local category = Settings.RegisterCanvasLayoutCategory(aboutPanel, "InfoStrip |T" .. categoryIcon .. ":18:18:0:0|t")
    Settings.RegisterAddOnCategory(category)

    Settings.RegisterCanvasLayoutSubcategory(category, generalPanel, InfoStrip:L("general"))
    Settings.RegisterCanvasLayoutSubcategory(category, appearancePanel, InfoStrip:L("appearance"))
    Settings.RegisterCanvasLayoutSubcategory(category, advancedPanel, InfoStrip:L("advanced"))

    self.category = category
    self.categoryID = category:GetID()
end

function Options:Open()
    if Settings and self.categoryID then
        Settings.OpenToCategory(self.categoryID)
        print("|cff00ff00InfoStrip:|r " .. InfoStrip:L("optionsOpened"))
    else
        print("|cffff0000InfoStrip:|r " .. InfoStrip:L("optionsUnavailable"))
    end
end
