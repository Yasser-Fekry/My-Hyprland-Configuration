-- dms/binds-user.lua
-- Optional per-user keybind overrides (managed by DMS). Loaded after default binds.
--
-- Every action goes through exec_cmd + hyprctl/CLI tools, so this works
-- regardless of which hl.dsp.* helpers your Hyprland build exposes.
-- If a bind already exists in your main config / DMS defaults, delete the duplicate here.

local function run(cmd) return hl.dsp.exec_cmd(cmd) end
local function dispatch(args) return hl.dsp.exec_cmd("hyprctl dispatch " .. args) end

---------------------------------------------------------------------------
-- Your existing binds
---------------------------------------------------------------------------
hl.bind("CTRL + SHIFT + T", run("~/.local/bin/ocr.sh"))
hl.bind("SUPER + Return",   run("kitty"))
hl.bind("SUPER + E",        run("thunar"))
hl.bind("CTRL + Home",      run("~/Scripts/screenshot.sh"))
hl.bind("Scroll_Lock",      run("brightnessctl --device='*::scrolllock' set 1"))
hl.bind("SUPER + D",        run("rofi -show drun -show-icons"))
-- hl.bind("SUPER + minus", run("bash ~/.local/bin/hypr-minimize.sh"))

---------------------------------------------------------------------------
-- Window management
---------------------------------------------------------------------------
hl.bind("SUPER + Q",         dispatch("killactive"))
hl.bind("SUPER + V",         dispatch("togglefloating"))
hl.bind("SUPER + F",         dispatch("fullscreen 0"))        -- real fullscreen
hl.bind("SUPER + SHIFT + F", dispatch("fullscreen 1"))        -- maximize (keeps bar)
hl.bind("SUPER + P",         dispatch("pin"))                 -- pin floating window on all workspaces
hl.bind("SUPER + J",         dispatch("togglesplit"))         -- flip split direction (dwindle)
hl.bind("SUPER + C",         dispatch("centerwindow"))

-- Focus (SUPER + arrows / vim keys)
hl.bind("SUPER + left",  dispatch("movefocus l"))
hl.bind("SUPER + right", dispatch("movefocus r"))
hl.bind("SUPER + up",    dispatch("movefocus u"))
hl.bind("SUPER + down",  dispatch("movefocus d"))
hl.bind("SUPER + H",     dispatch("movefocus l"))
hl.bind("SUPER + L",     dispatch("movefocus r"))
hl.bind("SUPER + K",     dispatch("movefocus u"))

-- Move windows
hl.bind("SUPER + SHIFT + left",  dispatch("movewindow l"))
hl.bind("SUPER + SHIFT + right", dispatch("movewindow r"))
hl.bind("SUPER + SHIFT + up",    dispatch("movewindow u"))
hl.bind("SUPER + SHIFT + down",  dispatch("movewindow d"))

-- Resize (keyboard)
hl.bind("SUPER + CTRL + left",  dispatch("resizeactive -40 0"))
hl.bind("SUPER + CTRL + right", dispatch("resizeactive 40 0"))
hl.bind("SUPER + CTRL + up",    dispatch("resizeactive 0 -40"))
hl.bind("SUPER + CTRL + down",  dispatch("resizeactive 0 40"))

-- Cycle windows on the current workspace
hl.bind("ALT + Tab",         dispatch("cyclenext"))
hl.bind("ALT + SHIFT + Tab", dispatch("cyclenext prev"))

---------------------------------------------------------------------------
-- Workspaces (1-9, 0 = 10)
---------------------------------------------------------------------------
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind("SUPER + " .. key,           dispatch("workspace " .. i))
    hl.bind("SUPER + SHIFT + " .. key,   dispatch("movetoworkspace " .. i))
    hl.bind("SUPER + ALT + " .. key,     dispatch("movetoworkspacesilent " .. i))
end

hl.bind("SUPER + mouse_down", dispatch("workspace e+1"))
hl.bind("SUPER + mouse_up",   dispatch("workspace e-1"))
hl.bind("SUPER + Tab",        dispatch("workspace previous"))

-- Scratchpad (special workspace)
hl.bind("SUPER + S",         dispatch("togglespecialworkspace magic"))
hl.bind("SUPER + SHIFT + S", dispatch("movetoworkspace special:magic"))

---------------------------------------------------------------------------
-- Apps / utilities
---------------------------------------------------------------------------
hl.bind("SUPER + B",         run("firefox"))
hl.bind("SUPER + SHIFT + V", run("cliphist list | rofi -dmenu | cliphist decode | wl-copy")) -- clipboard history
hl.bind("SUPER + SHIFT + C", run("hyprpicker -a"))                                           -- color picker -> clipboard
hl.bind("SUPER + SHIFT + L", run("loginctl lock-session"))                                   -- lock screen
hl.bind("SUPER + SHIFT + R", run("hyprctl reload"))                                          -- reload config

-- Region screenshot -> clipboard / saved file
hl.bind("Print",         run('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SHIFT + Print", run('grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%F_%H-%M-%S).png'))
hl.bind("CTRL + Print",  run('grim - | wl-copy'))   -- full screen -> clipboard

---------------------------------------------------------------------------
-- Media keys (locked = work on lock screen, repeating = hold to repeat)
---------------------------------------------------------------------------
local hold = { locked = true, repeating = true }
local lock = { locked = true }

hl.bind("XF86AudioRaiseVolume",  run("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), hold)
hl.bind("XF86AudioLowerVolume",  run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        hold)
hl.bind("XF86AudioMute",         run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       lock)
hl.bind("XF86AudioMicMute",      run("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     lock)
hl.bind("XF86MonBrightnessUp",   run("brightnessctl set 5%+"),                            hold)
hl.bind("XF86MonBrightnessDown", run("brightnessctl set 5%-"),                            hold)
hl.bind("XF86AudioPlay",         run("playerctl play-pause"),                             lock)
hl.bind("XF86AudioNext",         run("playerctl next"),                                   lock)
hl.bind("XF86AudioPrev",         run("playerctl previous"),                               lock)