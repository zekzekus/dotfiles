--------------------------------------------------------------------------------
-- zekzekus - https://github.com/zekzekus
-- Forked from: rtoshiro - https://github.com/rtoshiro/hammerspoon-init.git
-- You should see: http://www.hammerspoon.org/docs/index.html
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- KIND OF IMPORTS
--------------------------------------------------------------------------------
local window = require "hs.window"
local screen = require "hs.screen"
local hotkey = require "hs.hotkey"
local hints = require "hs.hints"
local application = require "hs.application"
local alert = require "hs.alert"
local appfinder = require "hs.appfinder"

--------------------------------------------------------------------------------
-- CONSTANTS
--------------------------------------------------------------------------------
local hyper = {"shift", "cmd", "alt", "ctrl"}
local cmd_alt_ctrl = {"cmd", "alt", "ctrl"}
local main_monitor = "Color LCD"
local second_monitor = "DELL S2340L"

--------------------------------------------------------------------------------
-- CONFIGURATIONS
--------------------------------------------------------------------------------
window.animationDuration = 0
window.setShadows(false)

--------------------------------------------------------------------------------
-- LAYOUTS
-- SINTAX:
--  {
--    name = "App name" ou { "App name", "App name" }
--    func = function(index, win)
--      COMMANDS
--    end
--  },
--
-- It searches for application "name" and call "func" for each window object
--------------------------------------------------------------------------------
local layouts = {
  {
    name = {"Google Chrome", "Calendar", "Spotify", "Hipchat", "Evernote", "Slack"},
    func = function(index, win)
      win:moveToScreen(screen.get(main_monitor))
      win:maximize()
    end
  },
  {
    name = "iTerm2",
    func = function(index, win)
      if (#screen.allScreens() > 1) then
        win:moveToScreen(screen.get(second_monitor))
      end

      if (index == 1) then
        win:left()
        elseif (index == 2) then
          win:right()
        end
      end
    }
  }

  local closeAll = {
    "Google Chrome",
    "Calendar",
    "Spotify",
    "Hipchat",
    "Evernote",
    "Slack",
    "iTunes",
    "Messages",
    "Preview",
  }

  local openAll = {
    "Google Chrome",
    "Hipchat",
    "iTerm"
  }


  function config()
    hotkey.bind(hyper, "l", function()
      local win = window.focusedWindow()
      win:right()
    end)

    hotkey.bind(hyper, "h", function()
      local win = window.focusedWindow()
      win:left()
    end)

    hotkey.bind(hyper, "k", function()
      local win = window.focusedWindow()
      win:up()
    end)

    hotkey.bind(hyper, "j", function()
      local win = window.focusedWindow()
      win:down()
    end)

    hotkey.bind(cmd_alt_ctrl, "h", function()
      local win = window.focusedWindow()
      win:upLeft()
    end)

    hotkey.bind(cmd_alt_ctrl, "j", function()
      local win = window.focusedWindow()
      win:downLeft()
    end)

    hotkey.bind(cmd_alt_ctrl, "k", function()
      local win = window.focusedWindow()
      win:downRight()
    end)

    hotkey.bind(cmd_alt_ctrl, "l", function()
      local win = window.focusedWindow()
      win:upRight()
    end)

    hotkey.bind(hyper, "c", function()
      local win = window.focusedWindow()
      window.fullscreenCenter(win)
    end)

    hotkey.bind(cmd_alt_ctrl, "c", function()
      local win = window.focusedWindow()
      window.fullscreenAlmostCenter(win)
    end)

    hotkey.bind(hyper, "f", function()
      local win = window.focusedWindow()
      win:maximize()
    end)

    hotkey.bind(cmd_alt_ctrl, "f", function()
      local win = window.focusedWindow()
      if (win) then
        window.fullscreenWidth(win)
      end
    end)

    hotkey.bind(hyper, "i", function()
      hints.windowHints()
    end)

    hotkey.bind(hyper, "1", function()
      local win = window.focusedWindow()
      if (win) then
        win:moveToScreen(screen.get(second_monitor))
      end
    end)

    hotkey.bind(hyper, "2", function()
      local win = window.focusedWindow()
      if (win) then
        win:moveToScreen(screen.get(main_monitor))
      end
    end)

    hotkey.bind(hyper, "r", function()
      hs.reload()
      alert.show("Config loaded!")
    end)

    hotkey.bind(cmd_alt_ctrl, "p", function()
      alert.show("Closing")
      for i,v in ipairs(closeAll) do
        local app = application(v)
        if (app) then
          if (app.name) then
            alert.show(app:name())
          end
          if (app.kill) then
            app:kill()
          end
        end
      end
    end)

    hotkey.bind(cmd_alt_ctrl, "o", function()
      alert.show("Openning")
      for i,v in ipairs(openAll) do
        alert.show(v)
        application.open(v)
      end
    end)

    hotkey.bind(hyper, "3", function()
      applyLayouts(layouts)
    end)

    hotkey.bind(hyper, "4", function()

      local focusedWindow = window.focusedWindow()
      local app = focusedWindow:application()
      if (app) then
        applyLayout(layouts, app)
      end
    end)

    hotkey.bind(hyper, "b", function()
      application.launchOrFocus("Google Chrome")
    end)

    hotkey.bind(hyper, "t", function()
      application.launchOrFocus("iTerm")
    end)

    hotkey.bind(hyper, "m", function()
      application.launchOrFocus("Hipchat")
    end)
  end
  --------------------------------------------------------------------------------
  -- END CONFIGURATIONS
  --------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- METHODS - BECAREFUL :)
  --------------------------------------------------------------------------------
  function applyLayout(layouts, app)
    if (app) then
      local appName = app:title()
      for i, layout in ipairs(layouts) do
        if (type(layout.name) == "table") then
          for i, layAppName in ipairs(layout.name) do
            if (layAppName == appName) then
              local wins = app:allWindows()
              local counter = 1
              for j, win in ipairs(wins) do
                if (win:isVisible() and layout.func) then
                  layout.func(counter, win)
                  counter = counter + 1
                end
              end
            end
          end
          elseif (type(layout.name) == "string") then
            if (layout.name == appName) then
              local wins = app:allWindows()
              local counter = 1
              for j, win in ipairs(wins) do
                if (win:isVisible() and layout.func) then
                  layout.func(counter, win)
                  counter = counter + 1
                end
              end
            end
          end
        end
      end
    end

    function applyLayouts(layouts)
      for i, layout in ipairs(layouts) do
        if (type(layout.name) == "table") then
          for i, appName in ipairs(layout.name) do
            local app = appfinder.appFromName(appName)
            if (app) then
              local wins = app:allWindows()
              local counter = 1
              for j, win in ipairs(wins) do
                if (win:isVisible() and layout.func) then
                  layout.func(counter, win)
                  counter = counter + 1
                end
              end
            end
          end
          elseif (type(layout.name) == "string") then
            local app = appfinder.appFromName(layout.name)
            if (app) then
              local wins = app:allWindows()
              local counter = 1
              for j, win in ipairs(wins) do
                if (win:isVisible() and layout.func) then
                  layout.func(counter, win)
                  counter = counter + 1
                end
              end
            end
          end
        end
      end

      function screen.get(screen_name)
        local allScreens = screen.allScreens()
        for i, screen in ipairs(allScreens) do
          if screen:name() == screen_name then
            return screen
          end
        end
      end

      -- Returns the width of the smaller screen size
      -- isFullscreen = false removes the toolbar
      -- and dock sizes
      function screen.minWidth(isFullscreen)
        local min_width = math.maxinteger
        local allScreens = screen.allScreens()
        for i, screen in ipairs(allScreens) do
          local screen_frame = screen:frame()
          if (isFullscreen) then
            screen_frame = screen:fullFrame()
          end
          min_width = math.min(min_width, screen_frame.w)
        end
        return min_width
      end

      -- isFullscreen = false removes the toolbar
      -- and dock sizes
      -- Returns the height of the smaller screen size
      function screen.minHeight(isFullscreen)
        local min_height = math.maxinteger
        local allScreens = screen.allScreens()
        for i, screen in ipairs(allScreens) do
          local screen_frame = screen:frame()
          if (isFullscreen) then
            screen_frame = screen:fullFrame()
          end
          min_height = math.min(min_height, screen_frame.h)
        end
        return min_height
      end

      -- If you are using more than one monitor, returns X
      -- considering the reference screen minus smaller screen
      -- = (MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2
      -- If using only one monitor, returns the X of ref screen
      function screen.minX(refScreen)
        local min_x = refScreen:frame().x
        local allScreens = screen.allScreens()
        if (#allScreens > 1) then
          min_x = refScreen:frame().x + ((refScreen:frame().w - screen.minWidth()) / 2)
        end
        return min_x
      end

      -- If you are using more than one monitor, returns Y
      -- considering the focused screen minus smaller screen
      -- = (MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2
      -- If using only one monitor, returns the Y of focused screen
      function screen.minY(refScreen)
        local min_y = refScreen:frame().y
        local allScreens = screen.allScreens()
        if (#allScreens > 1) then
          min_y = refScreen:frame().y + ((refScreen:frame().h - screen.minHeight()) / 2)
        end
        return min_y
      end

      -- If you are using more than one monitor, returns the
      -- half of minX and 0
      -- = ((MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2) / 2
      -- If using only one monitor, returns the X of ref screen
      function screen.almostMinX(refScreen)
        local min_x = refScreen:frame().x
        local allScreens = screen.allScreens()
        if (#allScreens > 1) then
          min_x = refScreen:frame().x + (((refScreen:frame().w - screen.minWidth()) / 2) - ((refScreen:frame().w - screen.minWidth()) / 4))
        end
        return min_x
      end

      -- If you are using more than one monitor, returns the
      -- half of minY and 0
      -- = ((MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2) / 2
      -- If using only one monitor, returns the Y of ref screen
      function screen.almostMinY(refScreen)
        local min_y = refScreen:frame().y
        local allScreens = screen.allScreens()
        if (#allScreens > 1) then
          min_y = refScreen:frame().y + (((refScreen:frame().h - screen.minHeight()) / 2) - ((refScreen:frame().h - screen.minHeight()) / 4))
        end
        return min_y
      end

      -- Returns the frame of the smaller available screen
      -- considering the context of refScreen
      -- isFullscreen = false removes the toolbar
      -- and dock sizes
      function screen.minFrame(refScreen, isFullscreen)
        return {
          x = screen.minX(refScreen),
          y = screen.minY(refScreen),
          w = screen.minWidth(isFullscreen),
          h = screen.minHeight(isFullscreen)
        }
      end

      -- +-----------------+
      -- |        |        |
      -- |        |  HERE  |
      -- |        |        |
      -- +-----------------+
      function window.right(win)
        local minFrame = screen.minFrame(win:screen(), false)
        minFrame.x = minFrame.x + (minFrame.w/2)
        minFrame.w = minFrame.w/2
        win:setFrame(minFrame)
      end

      -- +-----------------+
      -- |        |        |
      -- |  HERE  |        |
      -- |        |        |
      -- +-----------------+
      function window.left(win)
        local minFrame = screen.minFrame(win:screen(), false)
        minFrame.w = minFrame.w/2
        win:setFrame(minFrame)
      end

      -- +-----------------+
      -- |      HERE       |
      -- +-----------------+
      -- |                 |
      -- +-----------------+
      function window.up(win)
        local minFrame = screen.minFrame(win:screen(), false)
        minFrame.h = minFrame.h/2
        win:setFrame(minFrame)
      end

      -- +-----------------+
      -- |                 |
      -- +-----------------+
      -- |      HERE       |
      -- +-----------------+
      function window.down(win)
        local minFrame = screen.minFrame(win:screen(), false)
        minFrame.y = minFrame.y + minFrame.h/2
        minFrame.h = minFrame.h/2
        win:setFrame(minFrame)
      end

      -- +-----------------+
      -- |  HERE  |        |
      -- +--------+        |
      -- |                 |
      -- +-----------------+
      function window.upLeft(win)
        local minFrame = screen.minFrame(win:screen(), false)
        minFrame.w = minFrame.w/2
        minFrame.h = minFrame.h/2
        win:setFrame(minFrame)
      end

      -- +-----------------+
      -- |                 |
      -- +--------+        |
      -- |  HERE  |        |
      -- +-----------------+
      function window.downLeft(win)
        local minFrame = screen.minFrame(win:screen(), false)
        win:setFrame({
          x = minFrame.x,
          y = minFrame.y + minFrame.h/2,
          w = minFrame.w/2,
          h = minFrame.h/2
        })
      end

      -- +-----------------+
      -- |                 |
      -- |        +--------|
      -- |        |  HERE  |
      -- +-----------------+
      function window.downRight(win)
        local minFrame = screen.minFrame(win:screen(), false)
        win:setFrame({
          x = minFrame.x + minFrame.w/2,
          y = minFrame.y + minFrame.h/2,
          w = minFrame.w/2,
          h = minFrame.h/2
        })
      end

      -- +-----------------+
      -- |        |  HERE  |
      -- |        +--------|
      -- |                 |
      -- +-----------------+
      function window.upRight(win)
        local minFrame = screen.minFrame(win:screen(), false)
        win:setFrame({
          x = minFrame.x + minFrame.w/2,
          y = minFrame.y,
          w = minFrame.w/2,
          h = minFrame.h/2
        })
      end

      -- +------------------+
      -- |                  |
      -- |    +--------+    +--> minY
      -- |    |  HERE  |    |
      -- |    +--------+    |
      -- |                  |
      -- +------------------+
      -- Where the window's size is equal to
      -- the smaller available screen size
      function window.fullscreenCenter(win)
        local minFrame = screen.minFrame(win:screen(), false)
        win:setFrame(minFrame)
      end

      -- +------------------+
      -- |                  |
      -- |  +------------+  +--> minY
      -- |  |    HERE    |  |
      -- |  +------------+  |
      -- |                  |
      -- +------------------+
      function window.fullscreenAlmostCenter(win)
        local offsetW = screen.minX(win:screen()) - screen.almostMinX(win:screen())
        win:setFrame({
          x = screen.almostMinX(win:screen()),
          y = screen.minY(win:screen()),
          w = screen.minWidth(isFullscreen) + (2 * offsetW),
          h = screen.minHeight(isFullscreen)
        })
      end

      -- It like fullscreen but with minY and minHeight values
      -- +------------------+
      -- |                  |
      -- +------------------+--> minY
      -- |       HERE       |
      -- +------------------+--> minHeight
      -- |                  |
      -- +------------------+
      function window.fullscreenWidth(win)
        local minFrame = screen.minFrame(win:screen(), false)
        win:setFrame({
          x = win:screen():frame().x,
          y = minFrame.y,
          w = win:screen():frame().w,
          h = minFrame.h
        })
      end

      function applicationWatcher(appName, eventType, appObject)
        if (eventType == application.watcher.activated) then
          if (appName == "iTerm") then
            appObject:selectMenuItem({"Window", "Bring All to Front"})
            elseif (appName == "Finder") then
              appObject:selectMenuItem({"Window", "Bring All to Front"})
            end
          end

          if (eventType == application.watcher.launched) then
            os.execute("sleep " .. tonumber(3))
            applyLayout(layouts, appObject)
          end
        end

        config()
        local appWatcher = application.watcher.new(applicationWatcher)
        appWatcher:start()
