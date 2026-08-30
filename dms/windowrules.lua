-- Window rules. Deploy writes ~/.config/hypr/dms/windowrules.lua
-- dms/windowrules.lua
-- Window rules not already covered in the main hyprland.lua
-- App tiling
hl.window_rule({ match = { class = "^(org\\.telegram\\.desktop)$" }, tile = true })
-- Floating
hl.window_rule({ match = { class = "^(org\\.gnome\\.Shotwell)$" }, float = true })
-- Performance: disable blur/animation/force full opacity on heavy apps
local heavy_apps = {
    "firefox",
    "brave-browser",
    "google-chrome",
    "chromium",
    "VirtualBox Machine",
    "VirtualBox Manager",
    "mpv",
}
for _, class in ipairs(heavy_apps) do
    hl.window_rule({
        match = { class = "^(" .. class .. ")$" },
        no_blur = true,
        opacity = "1.0 override 1.0 override",
        animation = "none",
    })
end
hl.window_rule({ match = { class = "^(Spotify)$" }, opacity = "1.0 override 1.0 override" })
-- mpv: floating, centered, fixed size
hl.window_rule({ match = { class = "^(mpv)$" }, float = true })
hl.window_rule({ match = { class = "^(mpv)$" }, center = true })
hl.window_rule({ match = { class = "^(mpv)$" }, size = "1280 720" })
-- fdm: floating, centered, fixed size
hl.window_rule({ match = { class = "^(fdm)$" }, float = true })
hl.window_rule({ match = { class = "^(fdm)$" }, center = true })
hl.window_rule({ match = { class = "^(fdm)$" }, size = "1280 720" })
-- Evince (PDF viewer): floating, centered
hl.window_rule({ match = { class = "^(org.gnome.Evince)$" }, float = true })
hl.window_rule({ match = { class = "^(org.gnome.Evince)$" }, center = true })
-- Global blur off, re-enabled only for select apps
hl.window_rule({ match = { class = ".*" }, no_blur = true })
local blur_allowed = { "thunar", "code", "kitty", "md.obsidian.Obsidian" }
for _, class in ipairs(blur_allowed) do
    hl.window_rule({
        match = { class = "^(" .. class .. ")$" },
        no_blur = false,
        rounding = 12,
        opacity = "0.92 override 0.90 override",
    })
end