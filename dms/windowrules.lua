-- dms/windowrules.lua
-- Deploy writes ~/.config/hypr/dms/windowrules.lua
-- Rules not already covered in the main hyprland.lua
--
-- NOTE: in Hyprland later rules override earlier ones, so the order here is:

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

-- Build an anchored regex that matches any class in the list: ^(a|b|c)$
local function classes(list)
    local escaped = {}
    for _, c in ipairs(list) do
        escaped[#escaped + 1] = (c:gsub("([%.%+%-%*%?%[%]%(%)%^%$])", "\\%1"))
    end
    return "^(" .. table.concat(escaped, "|") .. ")$"
end

-- Apply one rule to a list of classes (extra props go in `props`)
local function rule(list, props)
    props.match = { class = classes(list) }
    hl.window_rule(props)
end

---------------------------------------------------------------------------
-- 1) Global defaults: blur OFF everywhere, enabled only for select apps
---------------------------------------------------------------------------
hl.window_rule({ match = { class = ".*" }, no_blur = true })

-- Blur + transparency apps (class names taken from `hyprctl clients`)
rule({
    "thunar",
    "Thunar",
    "com.microsoft.VSCode",
    "kitty",
    "sublime_text",
    "dev.noctalia.Noctalia",
    "md.obsidian.Obsidian"
}, {
    no_blur  = false,
    rounding = 12,
    opacity  = "0.92 override 0.90 override",
})

-- Kitty: don't let it force itself fullscreen/maximized
rule({ "kitty" }, {
    suppress_event = "fullscreen maximize",
})

---------------------------------------------------------------------------
-- 2) Performance: heavy apps -> no blur, full opacity, no animation
---------------------------------------------------------------------------
rule({
    -- browsers
    "firefox", "brave-browser", "google-chrome", "chromium",
    -- media
    "mpv", "Spotify",
    -- virtualization
    "VirtualBox", "VirtualBox Manager", "VirtualBox Machine",
    "VirtualBox VM", "VirtualBoxVM",
}, {
    no_blur   = true,
    opacity   = "1.0 override 1.0 override",
    animation = "none",
})

-- Brave PWAs (class looks like brave-<id>-Default, so it needs a real regex)
hl.window_rule({
    match     = { class = "^brave-.*" },
    no_blur   = true,
    opacity   = "1.0 override 1.0 override",
    animation = "none",
})

---------------------------------------------------------------------------
-- 3) Tiling / floating behavior
---------------------------------------------------------------------------

-- Always tiled
rule({ "org.telegram.desktop" }, { tile = true })

-- Floating, centered, fixed 1280x720
rule({ "mpv", "fdm" }, {
    float  = true,
    center = true,
    size   = "1280 720",
})

-- Floating, centered image viewer (imv-dir is a wrapper, real class is imv)
rule({ "imv", "imv-dir" }, {
    float  = true,
    center = true,
    size   = "1000 700",
})

-- Floating + centered (size left to the app)
rule({ "org.gnome.Evince", "org.gnome.Shotwell" }, {
    float  = true,
    center = true,
})

-- VirtualBox: VM viewports always float so they don't get squashed by tiling
rule({ "VirtualBox VM", "VirtualBoxVM", "VirtualBox Machine" }, {
    float  = true,
    center = true,
})

-- VirtualBox: dialogs (Settings / Preferences) float
for _, suffix in ipairs({ "Settings", "Preferences" }) do
    hl.window_rule({
        match  = { class = classes({ "VirtualBox", "VirtualBox Manager" }), title = ".* - " .. suffix },
        float  = true,
        center = true,
    })
end

---------------------------------------------------------------------------
-- 4) Generic dialogs -> float (file pickers, auth prompts, etc.)
---------------------------------------------------------------------------
hl.window_rule({
    match  = { title = "^(Open File|Save File|Save As|Choose.*|Select.*|Authentication Required)$" },
    float  = true,
    center = true,
})

---------------

hl.window_rule({ match = { class = ".*" }, no_initial_focus = false })

----

-- Obsidian: Settings window floats
hl.window_rule({
    match = {
        class = "^md\\.obsidian\\.Obsidian$",
        title = "^Settings - .*",
    },
    float  = true,
    center = true,
    size   = "1000 700",
})

-- Obsidian: Community Plugins window floats

hl.window_rule({
    match = {
        class = "^md\\.obsidian\\.Obsidian$",
        title = ".*Community plugins.*",
    },
    float  = true,
    center = true,
    size   = "1000 700",
})



---- Extension For All Browser 

hl.on("window.open", function(w)
    if w.class ~= "firefox" then return end
    if w.initial_title ~= "Mozilla Firefox" then return end

    local ff_windows = hl.get_windows({ class = "firefox" })
    if #ff_windows <= 1 then return end

    hl.dispatch(hl.dsp.window.float({ action = "set", window = w }))

    local sub
    sub = hl.on("window.title", function(tw)
        if tw.address ~= w.address then return end
        if tw.title == ""
            or tw.title == "Mozilla Firefox"
            or tw.title == "about:blank"
            or tw.title:match("^about:.*Mozilla Firefox$") then return end

        sub:remove()

        if tw.title:match("^Extension:") then
            hl.dispatch(hl.dsp.window.resize({ x = 800, y = 600, window = tw }))
            hl.dispatch(hl.dsp.window.center({ window = tw }))
            hl.dispatch(hl.dsp.focus({ window = tw }))
        else
            hl.dispatch(hl.dsp.window.float({ action = "unset", window = tw }))
        end
    end)
end)
