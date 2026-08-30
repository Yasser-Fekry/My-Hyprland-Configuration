-- Optional per-user keybind overrides (managed by DMS). Loaded after default binds.
-- dms/binds-user.lua
-- Custom keybinds

hl.bind("CTRL + SHIFT + T", hl.dsp.exec_cmd("~/.local/bin/ocr.sh"))
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty")) -- swap "kitty" for your terminal of choice
hl.bind("SUPER + E", hl.dsp.exec_cmd("thunar"))
hl.bind("CTRL + Home", hl.dsp.exec_cmd("~/Scripts/screenshot.sh"))
hl.bind("Scroll_Lock", hl.dsp.exec_cmd("brightnessctl --device='*::scrolllock' set 1"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("rofi -show drun -show-icons"))

--hl.bind("SUPER + minus", hl.dsp.exec_cmd("bash ~/.local/bin/hypr-minimize.sh"))
--
--

