-- Mob

-- CONSTANTS ------------------------------------

leftParam = "left"
rightParam = "right"

fuelThreshold = 100 -- the minimum amount of fuel needed
coal = "Coal"       -- name of fuel



-- FUNCTIONS ------------------------------------

-- go forward n spaces
function forward(n)
    n = n or 1
    for i=1,n do
        turtle.forward()
    end
end

-- go back n spaces
function back(n)
    n = n or 1
    for i=1,n do
        turtle.back()
    end
end

-- go down n spaces
function down(n)
    n = n or 1
    for i=1,n do
        turtle.down()
    end
end

-- go up n spaces
function up(n)
    n = n or 1
    for i=1,n do
        turtle.up()
    end
end

-- turn right n times
function right(n)
    n = n or 1
    for i=1,n do
        turtle.turnRight()
    end
end

-- turn left n times
function left(n)
    n = n or 1
    for i = 1,n do
        turtle.turnLeft()
    end
end

-- send a message to the monitor
function transmit(msg)
    modem = peripheral.wrap("right")
    modem.open(0)
    if modem ~= nil then
        modem.transmit(0,0,msg)
    end
end

-- refuel
function refuel(startingFuelLevel, side, oppositeSide)
    local chest = peripheral.wrap(side)
    if chest == nil then
        print("No chest found on "..side.." side!")
        return
    end

    local newFuelLevel = nil
    for i=1,27 do
        local slot = chest.getStackInSlot(i)
        if slot then
            if slot.name == coal then
                while true do
                    chest.pushItem(oppositeSide, i, 1, 1)
                    turtle.refuel()
                    newFuelLevel = turtle.getFuelLevel()
                    if (newFuelLevel > fuelThreshold) then
                        break
                    end
                end
            end
        end
    end

    if (newFuelLevel ~= nil and newFuelLevel > fuelThreshold) then
        print("Refuel successful!  "..startingFuelLevel.." -> "..newFuelLevel)
        return true
    else
        print("Refuel unsuccessful!")
        return false
    end
end

-- searches for the specific mob name
-- returns the slot in the chest the net is in
-- returns -1 if it's not found
function getSlotInChest(mob)
	local chest = peripheral.wrap("bottom")
	for i=1,27 do
        local slot = chest.getStackInSlot(i)
        if slot then
            if slot.name == mob then
                return i
            end
        end
    end
    return -1
end

-- actually getting the net from the chest
-- technically, should never fail from the prevalidation
function getNet(slot)
	transmit("Getting the net...")
	
	-- actually grab it
	local chest = peripheral.wrap("bottom")
	chest.pushItem("up", slot, 1, 1)
	transmit("Got it!")
end

-- go to the specific spawner
-- TODO make this cleaner
function goToSpawner(spawner)
    transmit("Going to "..spawner.." spawner...")
    right(2)
    forward()
    down(3)
    right(2)
    forward(2)

    if spawner == leftParam then
        left()
    else
        right()
        forward()
    end

    forward(5)

    if spawner == leftParam then
        right()
    else
        left()
    end

    forward(2)
    down()

    if spawner == leftParam then
        right()
    else 
        left()
    end

    redstone.setOutput("front", true)
    os.sleep(1)
    redstone.setOutput("front", false)

    if spawner == leftParam then
        left()
    else 
        right()
    end

    forward(6)
    transmit("Done.")
end

-- replaces the net in the spawner
function replaceNet()
    transmit("Replacing net...")
    local spawner = peripheral.wrap("top")
	if isEmpty(spawner.getStackInSlot(1)) then
		-- no net in there
    else
		spawner.pushItem("down", 1, 1, 2)
	end
	
	-- put the new net in the spawner
    turtle.dropUp(1)
    transmit("Done.")
end

-- checks if a string is empty
function isEmpty(s)
    return s == nil or s == ''
end

-- go back to the starting position
function goBackToBase(spawner)
    transmit("Going back to base from "..spawner.." spawner...")
    right(2)
    forward(6)

    if spawner == leftParam then
        left()
    else 
        right()
    end

    redstone.setOutput("front", true)
    os.sleep(1)
    redstone.setOutput("front", false)

    if spawner == leftParam then
        right()
    else 
        left()
    end

    up()
    forward(2)

    if spawner == leftParam then
        left()
        forward(5)
        right()
    else
        right()
        forward(6)
        left()
    end

    forward(2)
    up(3)
    right(2)
    forward()
    transmit("Done.")
end

-- put the net from the spawner back into the chest
function returnNet()
    transmit("Returning net...")
	turtle.select(2)
    turtle.dropDown(1)
    transmit("Done")
end

-- PROGRAM START --------------------------------

-- usage ex: > mob pig left
local args = {...}
local mob = args[1]
local spawner = args[2]

-- make sure parameters are there at all
if mob == nil or spawner == nil then
    print("Not enough parameters!")
    print("  Usage: mob <mob> <left/right>")
    return
end

-- validate left/right parameter first
if spawner == leftParam or spawner == rightParam then
    -- good parameter
else
    print("Bad spawner parameter: "..spawner)
    print("  Usage:  mob <mob> <left/right>")
    return
end

-- check for mob
local slot = getSlotInChest(mob)
if slot == -1 then
    print("Bad mob parameter: "..mob)
    print("Either bad input or no mob found...")
    print("  Usage:  mob <mob> <left/right>")
    return
end

-- check for fuel
local fuelLevel = turtle.getFuelLevel()
if fuelLevel < fuelThreshold then
    print("Fuel level is low ("..fuelLevel.."), refueling!")
    if not refuel(fuelLevel, "bottom", "up") then
        return
    end
end

print("Spawning "..mob.." in "..spawner.." spawner...")
print("Check monitor for progress...")

transmit("Spawning "..mob.." in "..spawner.." spawner...")
 
getNet(slot)            -- grab the net from the chest
goToSpawner(spawner)    -- move to the spawner
replaceNet()            -- replace the net that is currently being spawned
goBackToBase(spawner)   -- get back to base
returnNet()             -- put the replaced net back into the chest
 
-- reset
turtle.select(1)

transmit("Mission success!")

-- PROGRAM END ----------------------------------