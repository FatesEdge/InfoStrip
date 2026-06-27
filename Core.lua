local frame = CreateFrame("Frame", "InfoStripFrame", UIParent)

frame:SetSize(420, 24)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 220)

frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
frame.text:SetPoint("CENTER")
frame.text:SetText("InfoStrip loading...")

local elapsedSinceUpdate = 0

frame:SetScript("OnUpdate", function(self, elapsed)
    elapsedSinceUpdate = elapsedSinceUpdate + elapsed

    if elapsedSinceUpdate < 1 then
        return
    end

    elapsedSinceUpdate = 0

    local fps = math.floor(GetFramerate() + 0.5)
    local bandwidthIn, bandwidthOut, homeLatency, worldLatency = GetNetStats()

    self.text:SetText(string.format(
        "InfoStrip  FPS: %d  Home: %dms  World: %dms",
        fps,
        homeLatency,
        worldLatency
    ))
end)

print("|cff00ff00InfoStrip loaded.|r")
