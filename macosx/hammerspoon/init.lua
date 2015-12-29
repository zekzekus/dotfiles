local hyper = {"shift", "cmd", "alt", "ctrl"}

-----------------------------------------------
-- Hyper i to show window hints
-----------------------------------------------
hs.hotkey.bind(hyper, "i", function()
    hs.hints.windowHints()
end)

-----------------------------------------------
-- Hyper f make window full screen
-----------------------------------------------
hs.hotkey.bind(hyper, "f", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h

    win:setFrame(f)
end)

function reload_config(files)
    hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")
