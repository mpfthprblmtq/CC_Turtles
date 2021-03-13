--[[
    File:           counter_screen
    Created by:     mpfthprblmtq
    Last modified:  11/21/2020
 
    Description:    An attempt at a quarry counter
                    This program is meant to go on a computer with a 4x4 monitor above it
                    A modem should be attached to the left side of the computer (left frome player perspective)
--]] 

-- CONSTANTS/GLOBALS ----------------------------

monitor = peripheral.wrap("top")
w, h = monitor.getSize()

-- modem
modem = peripheral.wrap("left")
updateChannel = 100
turtleControlChannel = 101
screenControlChannel = 102
modem.open(updateChannel)
modem.close(turtleControlChannel)
modem.open(screenControlChannel)

-- title to display at the top
title = "=== QUARRY COUNTER ==="

-- table fields
local mainTable = {}
local coordTable = {}

-- header fields
BLOCK_HEADER = "== BLOCKS =="
ORES_HEADER = "== ORES =="
GEMS_MINERALS_HEADER = "== GEMS/MINERALS =="
EVERYTHING_ELSE_HEADER = "= EVERYTHING ELSE ="

-------------------------------------------------

-- FUNCTIONS ------------------------------------

-- initializes the main table with all 0s
function initializeTable()
    mainTable["Cobblestone"] = 0
    mainTable["Dirt"] = 0
    mainTable["Gravel"] = 0
    mainTable["Sand"] = 0
    mainTable["Sandstone"] = 0
    mainTable["Marble"] = 0
    mainTable["Netherrack"] = 0
    mainTable["Soul Sand"] = 0
    mainTable["Iron Ore"] = 0
    mainTable["Gold Ore"] = 0
    mainTable["Copper Ore"] = 0
    mainTable["Tin Ore"] = 0
    mainTable["Silver Ore"] = 0
    mainTable["Lead Ore"] = 0
    mainTable["Aluminum Ore"] = 0
    mainTable["Ferrous Ore"] = 0
    mainTable["Yellorite Ore"] = 0
    mainTable["Uranium Ore"] = 0
    mainTable["Pig Iron"] = 0
    mainTable["Platinum"] = 0
    mainTable["Certus Quartz"] = 0
    mainTable["Certus Quartz Dust"] = 0
    mainTable["Nether Quartz"] = 0
    mainTable["Ruby"] = 0
    mainTable["Peridot"] = 0
    mainTable["Sapphire"] = 0
    mainTable["Coal"] = 0
    mainTable["Flint"] = 0
    mainTable["Obsidian"] = 0
    mainTable["Quantum Dust"] = 0
    mainTable["Redstone"] = 0
    mainTable["Lapis Lazuli"] = 0
    mainTable["Sulfur"] = 0
    mainTable["Niter"] = 0
    mainTable["Diamond"] = 0
    mainTable["Emerald"] = 0
    mainTable["Raw Silicon"] = 0
    mainTable["Miscellaneous"] = 0
end

-- a coordinate mapping table
-- format is "x:y:z" where x and y is the x,y of the label
-- and z is the column where the count begins
-- so for instance, "Dirt" would show at coordinate 1,5 
-- and the count would show at coordinate 1,12
function initializeCoordTable()
    -- blocks
    coordTable[BLOCK_HEADER] = "2:3:0"
    coordTable["Cobblestone"] = "1:4:12"
    coordTable["Dirt"] = "1:5:12"
    coordTable["Gravel"] = "1:6:12"
    coordTable["Sand"] = "1:7:12"
    coordTable["Sandstone"] = "1:8:12"
    coordTable["Marble"] = "1:9:12"
    coordTable["Netherrack"] = "1:10:12"
    coordTable["Soul Sand"] = "1:11:12"

    -- ores
    coordTable[ORES_HEADER] = "1:13:0"
    coordTable["Iron Ore"] = "1:14:12"
    coordTable["Gold Ore"] = "1:15:12"
    coordTable["Copper Ore"] = "1:16:12"
    coordTable["Tin Ore"] = "1:17:12"
    coordTable["Yellorite Ore"] = "1:18:12"
    coordTable["Uranium Ore"] = "1:19:12"
    coordTable["Silver Ore"] = "1:20:12"
    coordTable["Lead Ore"] = "1:21:12"
    coordTable["Ferrous Ore"] = "1:22:12"
    coordTable["Aluminum Ore"] = "1:23:12"
    coordTable["Pig Iron"] = "1:24:12"
    coordTable["Platinum"] = "1:25:12"

    -- gems/minerals
    coordTable[GEMS_MINERALS_HEADER] = "20:3:0"
    coordTable["Coal"] = "20:4:34"
    coordTable["Flint"] = "20:5:34"
    coordTable["Obsidian"] = "20:6:34"
    coordTable["Raw Silicon"] = "20:7:34"
    coordTable["Certus Quartz"] = "20:8:34"
    coordTable["Certus Quartz Dust"] = "20:9:34"
    coordTable["Nether Quartz"] = "20:10:34"
    coordTable["Ruby"] = "20:11:34"
    coordTable["Peridot"] = "20:12:34"
    coordTable["Sapphire"] = "20:13:34"
    coordTable["Redstone"] = "20:14:34"
    coordTable["Lapis Lazuli"] = "20:15:34"
    coordTable["Quantum Dust"] = "20:16:34"
    coordTable["Sulfur"] = "20:17:34"
    coordTable["Niter"] = "20:18:34"
    coordTable["Emerald"] = "20:19:34"
    coordTable["Diamond"] = "20:20:34"

    -- everything else
    coordTable[EVERYTHING_ELSE_HEADER] = "20:22:0"
    coordTable["Miscellaneous"] = "20:23:34"
end

-- kinda self explanatory
-- initializes the table with all the values
function initializeGui()
    -- background
    monitor.clear()
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.black)
    monitor.setTextScale(1)
    monitor.clear()

    -- title
    monitor.setTextColor(colors.red)
    monitor.setCursorPos(10, 1)
    monitor.write(title)

    -- blocks
    writeHeader(BLOCK_HEADER)
    writeItem("Cobblestone", "Cobble")
    writeItem("Dirt")
    writeItem("Gravel")
    writeItem("Sand", "Snad")
    writeItem("Sandstone", "Snadstone")
    writeItem("Marble")
    writeItem("Netherrack")
    writeItem("Soul Sand")

    -- ores
    writeHeader(ORES_HEADER)
    writeItem("Iron Ore", "Iron")
    writeItem("Gold Ore", "Gold")
    writeItem("Copper Ore", "Copper")
    writeItem("Tin Ore", "Tin")
    writeItem("Yellorite Ore", "Yellorite")
    writeItem("Uranium Ore", "Uranium")
    writeItem("Silver Ore", "Silver")
    writeItem("Lead Ore", "Lead")
    writeItem("Ferrous Ore", "Ferrous")
    writeItem("Aluminum Ore", "Aluminum")
    writeItem("Pig Iron")
    writeItem("Platinum")

    -- gems/minerals
    writeHeader(GEMS_MINERALS_HEADER)
    writeItem("Coal")
    writeItem("Flint")
    writeItem("Obsidian")
    writeItem("Raw Silicon", "Silicon")
    writeItem("Certus Quartz", "Cert Qtz")
    writeItem("Certus Quartz Dust", "Cert Qtz Dust")
    writeItem("Nether Quartz", "Nether Qtz")
    writeItem("Ruby")
    writeItem("Peridot")
    writeItem("Sapphire")
    writeItem("Redstone")
    writeItem("Lapis Lazuli")
    writeItem("Quantum Dust")
    writeItem("Sulfur")
    writeItem("Niter")
    writeItem("Emerald")
    writeItem("Diamond")

    -- other blocks
    writeHeader(EVERYTHING_ELSE_HEADER)
    writeItem("Miscellaneous", "Misc Stuff")
end

-- supplementary function used to display a header
function writeHeader(index)
  monitor.setTextColor(colors.blue)
  x, y, z = getCoords(coordTable[index])
  monitor.setCursorPos(x, y)
  monitor.write(index)
end

-- supplementary function used to display a row
-- otherwise this 5 line block of code would be 
-- duplicated a thousand times
-- and who wants that
function writeItem(index, displayName)
  if displayName == nil then
    displayName = index
  end

  if index == "Cobblestone" then
    print(mainTable[index])
  end

  monitor.setTextColor(colors.black)
  x, y, z = getCoords(coordTable[index])
  monitor.setCursorPos(x, y)
  monitor.write(displayName)
  monitor.setCursorPos(z, y)
  monitor.write(tostring(mainTable[index]))
end

function updateItem(index)
  x, y, z = getCoords(coordTable[index])
  monitor.setTextColor(colors.black)
  monitor.setCursorPos(z, y)
  monitor.write(tostring(mainTable[index]))
end

function reset()
    initializeTable()
    initializeCoordTable()
    initializeGui()
end

function stop()
    reset()
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.clear()
end

-- send a message to the main control unit
function transmit(channel, msg)
  if modem ~= nil then 
    modem.transmit(channel, channel, msg) 
  end
end

-- function that splits a string by a provided delimiter
-- if no delimiter is provided, default to a space delimiter
-- shamelessly stolen from the internet
function split(str, pat)
  local t = {}  -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
     if s ~= 1 or cap ~= "" then
        table.insert(t, cap)
     end
     last_end = e+1
     s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
     cap = str:sub(last_end)
     table.insert(t, cap)
  end
  
  if table.getn(t) == 2 then
    return t[1], t[2]
  elseif table.getn(t) == 3 then
    return t[1], t[2], t[3]
  else
    return nil
  end
end

function getCoords(str)
  x, y, z = split(str, ":")
  x_int = tonumber(x)
  y_int = tonumber(y)
  z_int = tonumber(z)
  return x_int, y_int, z_int
end

-------------------------------------------------

-- MAIN PROGRAM ---------------------------------

-- start by initializing everything
reset()
term.clear()
term.setCursorPos(1,1)
print("Running...")

while true do
  -- listen for modem messages
  e, modemSide, sendChannel, replyChannel, message =
    os.pullEvent("modem_message")

  if sendChannel == screenControlChannel then
    transmit(screenControlChannel, "ACK")
    if message == "reset" or message == "start" then
      reset()
    elseif message == "stop" then
      stop()
    end
  elseif sendChannel == updateChannel then

    -- split the string we got in the format Item:Quantity
    index, quantity = split(message, ":")

    -- parse it
    mainTable[index] = mainTable[index] + quantity 

    -- update the gui with the new amount
    updateItem(index)
  end
end

-------------------------------------------------
