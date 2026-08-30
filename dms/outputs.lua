-- Force-override DMS configuration for saturation
hl.monitor({ 
    output = "eDP-1", 
    mode = "1920x1080@60.008", 
    position = "0x0", 
    scale = 1, 
    vrr = 0, 
    bitdepth = 10, 
    cm = "hdr", 
    sdrsaturation = 1.6 
})
