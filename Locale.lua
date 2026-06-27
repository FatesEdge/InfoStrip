local InfoStrip = _G.InfoStrip

InfoStrip.locale = {
    enUS = {
        addonName = "InfoStrip",
        about = "About",
        general = "General",
        colors = "Colors",
        language = "Language",
        advanced = "Advanced",

        description = "A lightweight client status strip for World of Warcraft.",
        author = "Author",
        github = "GitHub",
        version = "Version",

        enabled = "Enable InfoStrip",
        locked = "Lock position",
        resetPosition = "Reset position",
        unlockHint = "When unlocked, drag InfoStrip with the left mouse button.",

        display = "Display",
        position = "Position",
        showFPS = "Show FPS",
        showHomeLatency = "Show Home latency",
        showWorldLatency = "Show World latency",
        showLocalTime = "Show local time",
        showServerTime = "Show server time",

        updateInterval = "Update interval",
        template = "Display template",
        templateHint = "Available tokens: {fps}, {home}, {world}, {local}, {server}. Use \\n for a new line and \\t for a tab.",

        fps = "FPS",
        home = "Home",
        world = "World",
        localTime = "Local",
        serverTime = "Server",

        optionsOpened = "Options opened.",
        optionsUnavailable = "Settings API is not available.",
        loaded = "loaded.",
        lockedMsg = "locked.",
        unlockedMsg = "unlocked. Drag with left mouse button.",
        resetMsg = "position reset.",
    },

    zhCN = {
        addonName = "InfoStrip",
        about = "首页",
        general = "综合",
        colors = "颜色",
        language = "语言",
        advanced = "高级",

        description = "一个轻量的 World of Warcraft 客户端状态显示条。",
        author = "作者",
        github = "GitHub",
        version = "版本",

        enabled = "启用 InfoStrip",
        locked = "锁定位置",
        resetPosition = "重置位置",
        unlockHint = "未锁定时，可以用鼠标左键拖动 InfoStrip。",

        display = "显示内容",
        position = "位置",
        showFPS = "显示帧数",
        showHomeLatency = "显示 Home 延迟",
        showWorldLatency = "显示 World 延迟",
        showLocalTime = "显示本机时间",
        showServerTime = "显示服务器时间",

        updateInterval = "更新间隔",
        template = "显示模板",
        templateHint = "可用占位符：{fps}, {home}, {world}, {local}, {server}。可以用 \\n 换行，用 \\t 制表。",

        fps = "帧数",
        home = "Home",
        world = "World",
        localTime = "本机",
        serverTime = "服务器",

        optionsOpened = "设置已打开。",
        optionsUnavailable = "当前客户端没有可用的 Settings API。",
        loaded = "已加载。",
        lockedMsg = "已锁定。",
        unlockedMsg = "已解锁，可以用鼠标左键拖动。",
        resetMsg = "位置已重置。",
    },

    zhTW = {
        addonName = "InfoStrip",
        about = "首頁",
        general = "綜合",
        colors = "顏色",
        language = "語言",
        advanced = "進階",

        description = "一個輕量的 World of Warcraft 客戶端狀態顯示條。",
        author = "作者",
        github = "GitHub",
        version = "版本",

        enabled = "啟用 InfoStrip",
        locked = "鎖定位置",
        resetPosition = "重置位置",
        unlockHint = "未鎖定時，可以用滑鼠左鍵拖動 InfoStrip。",

        display = "顯示內容",
        position = "位置",
        showFPS = "顯示幀數",
        showHomeLatency = "顯示 Home 延遲",
        showWorldLatency = "顯示 World 延遲",
        showLocalTime = "顯示本機時間",
        showServerTime = "顯示伺服器時間",

        updateInterval = "更新間隔",
        template = "顯示模板",
        templateHint = "可用佔位符：{fps}, {home}, {world}, {local}, {server}。可以用 \\n 換行，用 \\t 製表。",

        fps = "幀數",
        home = "Home",
        world = "World",
        localTime = "本機",
        serverTime = "伺服器",

        optionsOpened = "設定已開啟。",
        optionsUnavailable = "目前客戶端沒有可用的 Settings API。",
        loaded = "已載入。",
        lockedMsg = "已鎖定。",
        unlockedMsg = "已解鎖，可以用滑鼠左鍵拖動。",
        resetMsg = "位置已重置。",
    },
}

function InfoStrip:GetLocaleTable()
    local lang = InfoStripDB and InfoStripDB.language or "auto"

    if lang == "auto" then
        lang = GetLocale and GetLocale() or "enUS"
    end

    return self.locale[lang] or self.locale.enUS
end

function InfoStrip:L(key)
    local localeTable = self:GetLocaleTable()
    return localeTable[key] or self.locale.enUS[key] or key
end
