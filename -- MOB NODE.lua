-- MOB NODE

-- this one you put at the spawner with an engineering turtle

spawner = peripheral.wrap("top")
chest = peripheral.wrap("front")
modem = peripheral.wrap("right")

witherSkelly = "Wither Skeleton"
AUTO_SPAWNER = "tile.mfr.machine.autospawner.name"
AUTO_SPAWNER_EXACT = "Auto-Spawner (Exact)"

-- direction the turtle is from the chest
chestDirection = "east"

spawningExact = nil
modem.open(1)
modem.open(11)

function getSpawningExact()
    return chest.getStackInSlot(27).name ~= "Auto-Spawner (Exact)"
end

-- send a message to the main control unit
function transmit(msg)
    if modem ~= nil then
        modem.transmit(1,1,msg)
    end
end

-- replaces the spawner with the spawn exact one
function spawnExact()
    if not spawningExact then   -- check if we're already spawning exact
        auto_spawner = chest.getStackInSlot(27)
        if auto_spawner.name == AUTO_SPAWNER_EXACT then
            retrieveNet()   -- grab the net already in there first
            chest.pushItem(chestDirection, 27, 1, 1) -- grab the exact spawner
            turtle.digUp()  -- grab the old (non exact) spawner
            turtle.select(1)
            turtle.placeUp()    -- place the exact spawner
            chest.pullItem(chestDirection, 2, 1, 27)    -- put old spawner back
            spawningExact = true    -- set global
        else
            return false
        end
    end
    return true
end

-- replaces the exact spawner with the regular one
function dontSpawnExact()
    if spawningExact then
        auto_spawner = chest.getStackInSlot(27)
        if auto_spawner.name == AUTO_SPAWNER then
            retrieveNet()   -- grab the net already in there first
            chest.pushItem(chestDirection, 27, 1, 1) -- grab the regular spawner
            turtle.digUp()  -- grab the old (exact) spawner
            turtle.select(1)
            turtle.placeUp()    -- place the regular spawner
            chest.pullItem(chestDirection, 2, 1, 27)    -- put old spawner back
            spawningExact = false    -- set global
        else
            return false
        end
    end
    return true
end

function retrieveNet()
    os.sleep(5)
    if not spawner.getStackInSlot(1) then
		-- no net in there
    else
		spawner.pushItem("down", 1, 1, 2)
    end

    -- put the old net back
    turtle.select(2)
    turtle.drop()

    -- reset
    turtle.select(1)
end

function getNet(mobName)
    for i=1,27 do
        slot = chest.getStackInSlot(i)
        if slot then
            if mobName == witherSkelly then
                if slot.name == witherSkelly then
                    chest.pushItem(chestDirection, i, 1, 1)
                end
            end
            if slot.captured == mobName then
                chest.pushItem(chestDirection, i, 1, 1)
                break
            end
        end
    end
end

function replaceNet(mobName)
    -- get the net from the spawner
    retrieveNet()
    
    -- get the net from the ender chest
    getNet(mobName)
	
	-- put the new net in the spawner
    turtle.dropUp()
end

function getCurrentlySpawning()
    local net = spawner.getStackInSlot(1)
    if net
end

-- BEGIN PROGRAM --------------------------------

spawningExact = getSpawningExact()
turtle.select(1)

while true do
    e, modemSide, sendChannel, replyChannel, message = os.pullEvent("modem_message")

    if message == "get" then
        currentlySpawning = getCurrentlySpawning()
    else
        mobName = message
        -- special case to spawn exact
        if mobName == witherSkelly then
            if spawnExact() then
                -- all is well
            else
                transmit("Exact spawner wasn't found!")
            end
        else
            if dontSpawnExact() then
                -- all is well
            else
                transmit("Non-Exact spawner wasn't found!")
            end
        end
    end

    -- do the net replacement
    replaceNet(mobName)

    -- done, wait for next command
end