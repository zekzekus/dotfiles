-- -----------------
-- stolen from https://github.com/exark/dotfiles/tree/master/.hammerspoon
-- -----------------

-- -----------------
-- Setup environment
-- -----------------

-- None of this animation shit:
hs.window.animationDuration = 0
-- Get list of screens and refresh that list whenever screens are plugged or unplugged:
local screens = hs.screen.allScreens()
local screenwatcher = hs.screen.watcher.new(function()
  screens = hs.screen.allScreens()
end)
screenwatcher:start()

-- Modifier shortcuts
local alt = {"alt"}
local hyper = {"cmd", "alt", "ctrl", "shift"}
local nudgekey = {"alt", "ctrl"}
local yankkey = {"alt", "ctrl", "shift"}
local pushkey = {"ctrl", "cmd"}
local shiftpushkey= {"ctrl", "cmd", "shift"}

-- --------------------------------------------------------
-- Helper functions - these do all the heavy lifting below.
-- Names are roughly stolen from same functions in Slate :)
-- --------------------------------------------------------

-- Move a window a number of pixels in x and y
function nudge(xpos, ypos)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.x = f.x + xpos
  f.y = f.y + ypos
  win:setFrame(f)
end

-- Resize a window by moving the bottom
function yank(xpixels,ypixels)
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.w = f.w + xpixels
  f.h = f.h + ypixels
  win:setFrame(f)
end

-- Resize window for chunk of screen.
-- For x and y: use 0 to expand fully in that dimension, 0.5 to expand halfway
-- For w and h: use 1 for full, 0.5 for half
function push(x, y, w, h)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w*x)
  f.y = max.y + (max.h*y)
  f.w = max.w*w
  f.h = max.h*h
  win:setFrame(f)
end

-- Move to monitor x. Checks to make sure monitor exists, if not moves to last monitor that exists
function moveToMonitor(x)
  local win = hs.window.focusedWindow()
  local newScreen = nil
  while not newScreen do
    newScreen = screens[x]
    x = x-1
  end

  win:moveToScreen(newScreen)
end

-- Mouse circle example from getting started guide.
-- This places a red circle around the mouse pointer (because I lose it a lot)
local mouseCircle = nil
local mouseCircleTimer = nil

function mouseHighlight()
  -- Delete an existing highlight if it exists
  if mouseCircle then
    mouseCircle:delete()
    if mouseCircleTimer then
      mouseCircleTimer:stop()
    end
  end
  -- Get the current co-ordinates of the mouse pointer
  mousepoint = hs.mouse.get()
  -- Prepare a big red circle around the mouse pointer
  mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
  mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
  mouseCircle:setFill(false)
  mouseCircle:setStrokeWidth(5)
  mouseCircle:show()

  -- Set a timer to delete the circle after 3 seconds
  mouseCircleTimer = hs.timer.doAfter(2, function() mouseCircle:delete() end)
end

-- Help. Lists shortcuts, etc.
-- The terrible spacing looks fine when the alert is actually displayed
function showHelp()
  helpstr = [[Hyper                     ⌘⌥⌃⇧
  Nudge                           ⌥⌃
  Yank                          ⌥⌃⇧
  Push                              ⌘⌃

  Find pointer            Hyper-W]]
  hs.alert.show(helpstr)
end

--and magic (from getting started guide):
function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- -----------------
-- Keybindings
-- -----------------

-- Movement hotkeys
hs.hotkey.bind(nudgekey, 'down', function() nudge(0,100) end) 	--down
hs.hotkey.bind(nudgekey, "up", function() nudge(0,-100) end)	--up
hs.hotkey.bind(nudgekey, "right", function() nudge(100,0) end)	--right
hs.hotkey.bind(nudgekey, "left", function() nudge(-100,0) end)	--left

-- Resize hotkeys
hs.hotkey.bind(yankkey, "up", function() yank(0,-100) end) -- yank bottom up
hs.hotkey.bind(yankkey, "down", function() yank(0,100) end) -- yank bottom down
hs.hotkey.bind(yankkey, "right", function() yank(100,0) end) -- yank right side right
hs.hotkey.bind(yankkey, "left", function() yank(-100,0) end) -- yank right side left

-- Navigate hotkeys
hs.hotkey.bind(hyper, 'h', function() hs.window.focusedWindow():focusWindowWest() end)
hs.hotkey.bind(hyper, 'l', function() hs.window.focusedWindow():focusWindowEast() end)
hs.hotkey.bind(hyper, 'k', function() hs.window.focusedWindow():focusWindowNorth() end)
hs.hotkey.bind(hyper, 'j', function() hs.window.focusedWindow():focusWindowSouth() end)

-- Push to screen edge
hs.hotkey.bind(pushkey,"left", function() push(0,0,0.5,1) end) 		-- left side
hs.hotkey.bind(pushkey,"right", function() push(0.5,0,0.5,1) end)	-- right side
hs.hotkey.bind(pushkey,"up", function()	push(0,0,1,0.5) end) 		-- top half
hs.hotkey.bind(pushkey,"down", function()	push(0,0.5,1,0.5) end)	-- bottom half

-- Center window with some room to see the desktop
hs.hotkey.bind(pushkey, "g", function() push(0.05,0.05,0.9,0.9) end)

-- Fullscreen
hs.hotkey.bind(pushkey, "f", function() push(0,0,1,1) end)

-- Move a window between monitors
hs.hotkey.bind(pushkey,"1", function() moveToMonitor(1) end) -- Move to first monitor
hs.hotkey.bind(shiftpushkey,"1", function() 											 -- Move to first monitor and fullscreen
  moveToMonitor(1)
  push(0,0,1,1)
end)
hs.hotkey.bind(pushkey,"2", function() moveToMonitor(2) end) -- Move to second monitor
hs.hotkey.bind(shiftpushkey,"2", function() 											 -- Move to second monitor and fullscreen
  moveToMonitor(2)
  push(0,0,1,1)
end)

hs.hotkey.bind(hyper, "i", function() hs.hints.windowHints() end)

-- Application shortcuts
hs.hotkey.bind(hyper, "b", function() hs.application.launchOrFocus("Safari") end)
hs.hotkey.bind(hyper, "m", function() hs.application.launchOrFocus("Slack") end)
hs.hotkey.bind(hyper, "t", function() hs.application.launchOrFocus("iTerm") end)
hs.hotkey.bind(hyper, "n", function() hs.application.launchOrFocus("Agenda") end)
hs.hotkey.bind(hyper, "v", function() hs.application.launchOrFocus("Things3") end)
hs.hotkey.bind(hyper, "a", function()
  hs.application.launchOrFocus("Safari")
  hs.application.launchOrFocus("Slack")
  hs.application.launchOrFocus("iTerm")
  hs.application.launchOrFocus("Agenda")
  hs.application.launchOrFocus("Things3")
end)

hs.hotkey.bind(hyper, "w", mouseHighlight)

hs.hotkey.bind(hyper, "q", showHelp)

--config reloading. manual (from getting started guide):
hs.hotkey.bind(hyper, "r", function() hs.reload() end)
