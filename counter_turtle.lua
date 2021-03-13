--[[
    File:           counter
    Created by:     mpfthprblmtq
    Last modified:  11/20/2020
 
    Description:    An attempt at a quarry counter that takes items into a 
                    chest below the turtle, and counts and throws them into 
                    a chest above the turtle
--]]

-- CONSTANTS/GLOBALS ----------------------------

modem = peripheral.wrap("right")
updateChannel = 100
turtleControlChannel = 101
screenControlChannel = 102
modem.open(updateChannel)
modem.close(screenControlChannel)
modem.open(turtleControlChannel)

local input = peripheral.wrap("bottom")
local output = peripheral.wrap("top")
local miscChest = peripheral.wrap("left")

mainTable = {}

stopFlag = false

-------------------------------------------------
 
-- FUNCTIONS ------------------------------------

-- send a message to the main control unit
function transmit(channel, msg)
  if modem ~= nil then
      modem.transmit(channel,channel,msg)
  end
end

function initializeTable()
  mainTable["Cobblestone"] = "Cobblestone"
  mainTable["Dirt"] = "Dirt"
  mainTable["Gravel"] = "Gravel"
  mainTable["Sand"] = "Sand"
  mainTable["Sandstone"] = "Sandstone"
  mainTable["Marble"] = "Marble"
  mainTable["Netherrack"] = "Netherrack"
  mainTable["Soul Sand"] = "Soul Sand"
  mainTable["Iron Ore"] = "Iron Ore"
  mainTable["tile.netherores.ore.iron.name"] = "Iron Ore"
  mainTable["Gold Ore"] = "Gold Ore"
  mainTable["tile.netherores.ore.gold.name"] = "Gold Ore"
  mainTable["Copper Ore"] = "Copper Ore"
  mainTable["tile.netherores.ore.copper.name"] = "Copper Ore"
  mainTable["Tin Ore"] = "Tin Ore"
  mainTable["tile.netherores.ore.tin.name"] = "Tin Ore"
  mainTable["Silver Ore"] = "Silver Ore"
  mainTable["tile.netherores.ore.silver.name"] = "Silver Ore"
  mainTable["Lead Ore"] = "Lead Ore"
  mainTable["tile.netherores.ore.lead.name"] = "Lead Ore"
  mainTable["Aluminum Ore"] = "Aluminum Ore"
  mainTable["Ferrous Ore"] = "Ferrous Ore"
  mainTable["tile.netherores.ore.nickel.name"] = "Ferrous Ore" -- what?
  mainTable["tile.brOre.0.name"] = "Yellorite Ore"
  mainTable["tile.atomicscience:uraniumOre.name"] = "Uranium Ore"
  mainTable["Nether Uranium Ore"] = "Uranium Ore"
  mainTable["AppEng.Materials.QuartzCrystal.name"] = "Certus Quartz"
  mainTable["AppEng.Materials.QuartzDust.name"] = "Certus Quartz Dust"
  mainTable["Nether Quartz"] = "Nether Quartz"
  mainTable["Ruby"] = "Ruby"
  mainTable["tile.netherores.ore.ruby.name"] = "Ruby"
  mainTable["Peridot"] = "Peridot"
  mainTable["tile.netherores.ore.peridot.name"] = "Peridot"
  mainTable["Sapphire"] = "Sapphire"
  mainTable["tile.netherores.ore.sapphire.name"] = "Sapphire"
  mainTable["Coal"] = "Coal"
  mainTable["tile.netherores.ore.coal.name"] = "Coal"
  mainTable["Flint"] = "Flint"
  mainTable["Obsidian"] =  "Obsidian"
  mainTable["item.quantumdust.name"] = "Quantum Dust"
  mainTable["Redstone"] = "Redstone"
  mainTable["tile.netherores.ore.redstone.name"] = "Redstone"
  mainTable["Lapis Lazuli"] = "Lapis Lazuli"
  mainTable["tile.netherores.ore.lapis.name"] = "Lapis Lazuli"
  mainTable["Diamond"] = "Diamond"
  mainTable["tile.netherores.ore.diamond.name"] = "Diamond"
  mainTable["Emerald"] = "Emerald"
  mainTable["tile.netherores.ore.emerald.name"] = "Emerald"
  mainTable["Raw Silicon"] = "Raw Silicon"
  mainTable["tile.netherores.ore.platinum.name"] = "Platinum"
  mainTable["tile.netherores.ore.steel.name"] = "Pig Iron"
  mainTable["tile.netherores.ore.sulfur.name"] = "Sulfur"
  mainTable["tile.netherores.ore.saltpeter.name"] = "Niter"
end

function parseName(name)
  if mainTable[name] == nil then
    name = "Miscellaneous"
  else
    name = mainTable[name]
  end
  return name
end

function parseQty(name, qty)
  if name == "Nether Platinum Ore" 
    or name == "Nether Coal Ore" then
      qty = qty * 4
  elseif name == "Nether Diamond Ore"
    or name == "Nether Emerald Ore" then
      qty = qty * 5
  elseif name == "Nether Saltpeter Ore" then
    qty = qty * 10
  elseif name == "Nether Redstone Ore"
    or name == "Nether Lapis Ore"
    or name == "Nether Sulfur Ore" then
      qty = qty * 24
  end
  return qty
end

function go()
  while true do

    if stopFlag then
      stopFlag = false
      break
    end

    -- loop through the first 4 slots in the chest
    -- let's see if it keeps up
    for i=1,4 do
      local slot = input.getStackInSlot(i)
      if slot then
        input.pushItem("up", i)
        parsedName = parseName(slot.name)
        parsedQty = parseQty(slot.name, slot.qty)
        transmit(updateChannel, parsedName..":"..parsedQty)
        if parsedName == "Miscellaneous" then
          miscChest.pullItem("east", 1)
        else
          turtle.dropUp()
        end
      end
    end
  end
end

function start()
  parallel.waitForAll(go, listen)
end

function stop()
  stopFlag = true
  listen()
end

function listen()
  while true do

    -- listen for modem messages
    e, modemSide, sendChannel, replyChannel, message =
        os.pullEvent("modem_message")

    print("[DEBUG] Message recieved from control panel: "..message)
    transmit(turtleControlChannel, "ACK")
    if message == "start" then
      start()
    elseif message == "stop" then
      stop()
    end
  end
end

-------------------------------------------------

-- MAIN PROGRAM ---------------------------------

term.clear()
term.setCursorPos(1,1)
print("Running...")

-- check configuration
if input == nil or output == nil or miscChest == nil then
  print("Chest configuration is invalid, exiting!")
  return
end

initializeTable()

-- clear out inventory to start
turtle.select(1)
turtle.dropUp()

listen()

-------------------------------------------------