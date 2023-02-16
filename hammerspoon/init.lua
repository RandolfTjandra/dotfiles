-- Modifiers
meh = {"ctrl", "alt", "shift"}
hyper = {"cmd", "ctrl", "alt", "shift"}

-- Window Grid
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.setGrid('3x1')

-- Disable animations
hs.window.animationDuration = 0

--  Remapping arrow keys
-- local function pressFn(mods, key)
-- 	if key == nil then
-- 		key = mods
-- 		mods = {}
-- 	end

-- 	return function() hs.eventtap.keyStroke(mods, key, 1000) end
-- end

-- local function remap(mods, key, pressFn)
-- 	hs.hotkey.bind(mods, key, pressFn, nil, pressFn)
-- end

-- remap(meh, 'j', pressFn('left'))
-- remap(meh, 'k', pressFn('down'))
-- remap(meh, 'i', pressFn('up'))
-- remap(meh, 'l', pressFn('right'))

-- Reload Config Watcher
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
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- Show now playing
hs.hotkey.bind(meh, "A", function()
  local title = "Now Playing: " .. hs.itunes.getCurrentTrack()
  local subtitle = "by " .. hs.itunes.getCurrentArtist()
  hs.notify.new({title=title, informativeText=subtitle}):send()
end)

-- Left Half 
-- function leftHalf()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()
--   local screen = win:screen()
--   local max = screen:frame()

--   f.x = max.x
--   f.y = max.y
--   f.w = max.w / 2
--   f.h = max.h
--   win:setFrame(f, 0)
-- end
-- hs.hotkey.bind(hyper, "Left", leftHalf)
-- hs.hotkey.bind(hyper, "j", leftHalf)
-- hs.hotkey.bind({"cmd", "alt", "shift"}, "j", leftHalf)

-- Right Half
-- function rightHalf()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()
--   local screen = win:screen()
--   local max = screen:frame()

--   f.x = max.x + (max.w / 2)
--   f.y = max.y
--   f.w = max.w / 2
--   f.h = max.h
--   win:setFrame(f, 0)
-- end
-- hs.hotkey.bind(hyper, "Right", rightHalf)
-- hs.hotkey.bind(hyper, "l", rightHalf)
-- hs.hotkey.bind({"cmd", "alt", "shift"}, "l", rightHalf)

-- Full screen
-- function fullScreen()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()
--   local screen = win:screen()
--   local max = screen:frame()

--   f.x = max.x
--   f.y = max.y
--   f.w = max.w
--   f.h = max.h
--   win:setFrame(f, 0)
-- end

-- hs.hotkey.bind({"shift", "alt"}, 'F', fullScreen)
-- hs.hotkey.bind(hyper, 'F', fullScreen)

-- Center
-- hs.hotkey.bind({"shift", "alt"}, "C", function()
-- hs.hotkey.bind({"cmd", "alt"}, "C", function()
--   local primaryScreen = hs.screen.primaryScreen()
--   local mainScreen = hs.screen.mainScreen()
--   local screenX, screenY = mainScreen:position()
--   local win = hs.window.focusedWindow()
--   local frame = win:frame()
--   local screen = win:screen()
--   local max = screen:fullFrame()
--   frame.x = (primaryScreen:frame().w * screenX) + max.w / 2 - frame.w / 2
--   frame.y = max.h / 2 - frame.h / 2
--   win:setFrame(frame)
-- end)

-- Left column
-- function leftColumn()
--   function fn(cell)
--     cell.w = cell.w % 3 + 1
--     if cell.x > 0 then
--       cell.w = 1
--     end
--     cell.y = 0
--     cell.x = 0
--     return hs.grid
--   end
--   hs.grid.adjustWindow(fn)
-- end
-- -- Middle column
-- function middleColumn()
--   function fn(cell)
--     cell.w = cell.w % 2 + 1
--     if cell.x > 1 or cell.x < 1 then
--       cell.w = 1
--     end
--     cell.y = 0
--     cell.x = 1
--     return hs.grid
--   end
--   hs.grid.adjustWindow(fn)
-- end
-- -- Right column
-- function rightColumn()
--   function fn(cell)
--     cell.y = 0
--     cell.x = 2
--     cell.w = 1
--     return hs.grid
--   end
--   hs.grid.adjustWindow(fn)
-- end
-- hs.hotkey.bind({"ctrl", "cmd"}, 'j', leftColumn)
-- hs.hotkey.bind({"ctrl", "cmd"}, 'k', middleColumn)
-- hs.hotkey.bind({"ctrl", "cmd"}, 'l', rightColumn)

-- Move window to next screen
-- function nextScreen()
--   local win = hs.window.focusedWindow()
--   local screen = win:screen()
--   win:moveToScreen(screen:next(), 0)
-- end
-- hs.hotkey.bind(hyper, "Down", nextScreen)
-- hs.hotkey.bind(hyper, "k", nextScreen)

-- -- Move window to previous screen
-- function previousScreen()
--   local win = hs.window.focusedWindow()
--   local screen = win:screen()
--   win:moveToScreen(screen:previous(), 0)
-- end
-- hs.hotkey.bind(hyper, "Up", previousScreen)
-- hs.hotkey.bind(hyper, "i", previousScreen)

-- Volume Control
-- function changeVolume(diff)
--   return function()
--     local current = hs.audiodevice.defaultOutputDevice():volume()
--     local new = math.min(100, math.max(0, math.floor(current + diff)))
--     if new > 0 then
--       hs.audiodevice.defaultOutputDevice():setMuted(false)
--     end
--     hs.alert.closeAll(0.0)
--     hs.alert.show("Volume " .. new .. "%", {}, 0.5)
--     hs.audiodevice.defaultOutputDevice():setVolume(new)
--   end
-- end

-- function toggleMute()
--   local current = hs.audiodevice.defaultOutputDevice():muted()
--   local new = not current
--   hs.audiodevice.defaultOutputDevice():setMuted(new)
--   hs.alert.closeAll(0.0)
--   hs.alert.show("Volume " .. (new and "muted" or "unmuted"), {}, 0.5)
-- end

-- hs.hotkey.bind(meh, 'q', changeVolume(-3))
-- hs.hotkey.bind(meh, 'w', changeVolume(3))
-- hs.hotkey.bind(meh, 'e', toggleMute)

