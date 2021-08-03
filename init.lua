-- System events
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "K", function()
  hs.caffeinate.shutdownSystem()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  if hs.wifi.currentNetwork() == nil then
    os.execute("networksetup -setairportpower en0 on")
  else
    os.execute("networksetup -setairportpower en0 off")
  end
end)

-- Launching applications
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "A", function()
  hs.application.launchOrFocus("Authy Desktop")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "T", function()
  hs.application.launchOrFocus("iTerm")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "G", function()
  hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "B", function()
  hs.application.launchOrFocus("Brave Browser")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "V", function()
  hs.application.launchOrFocus("MacVim")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "F", function()
  hs.application.launchOrFocus("Franz")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "S", function()
  hs.application.launchOrFocus("Signal")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function()
  hs.application.launchOrFocus("Postman")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Q", function()
  hs.application.launchOrFocus("PSequel")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "N", function()
  hs.application.launchOrFocus("Notion")
end)

-- Resizing windows
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + (max.h / 2)
  f.w = max.w
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Space", function()
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

-- Pathwatcher
function reloadConfig(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hello Sir Dominic!")

-- Wifi watcher
local homeSSID = "NETGEAR76"
local lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
  newSSID = hs.wifi.currentNetwork()

  if newSSID == homeSSID and lastSSID ~= homeSSID then
    hs.audiodevice.defaultOutputDevice():setVolume(50)
  elseif newSSID ~= homeSSID then
    hs.audiodevice.defaultOutputDevice():setVolume(0)
  end

  lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

-- Force paste
hs.hotkey.bind({"cmd", "alt"}, "V", function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

-- Battery watcher
function batteryChangedCallback()
  if hs.battery.isCharged() then
    hs.notify.new({title="Your battery is charged", informativeText="Please disconnect the charger.", soundName="Hero"}):send():release()
  end
end

batteryWatcher = hs.battery.watcher.new(batteryChangedCallback)
batteryWatcher:start()
