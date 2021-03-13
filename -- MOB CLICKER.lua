-- MOB CLICKER

monitor = peripheral.wrap("top")
w,h = monitor.getSize()
title = "=== MOB SPAWNER ==="

mobLookupTable = {}
lastMobClicked = nil
lastMobClickedCursorX = nil
lastMobClickedCursorY = nil

mobToSpawn = nil
spawnerToSpawnIn = nil
goodToSpawn = false

leftSpawnerFreq = 11
rightSpawnerFreq = 12

-- set up gui
function setUpGUI(mobs)

    -- background
    monitor.clear()
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.black)
    monitor.setTextScale(1)
    monitor.clear()

    -- title
    monitor.setCursorPos((w/2-#title/2)+1,1)
    monitor.setTextColor(colors.red)
    monitor.write(title)

    -- mob header
    monitor.setCursorPos(3,3)
    monitor.setTextColor(colors.green)
    monitor.write("============= MOBS =============")

    -- mob list
    mobLookupTable = {}
    xPos = 3
    yPos = 4
    monitor.setCursorPos(xPos,yPos)
    monitor.setTextColor(colors.black)

    for i=0,table.getn(mobs) do
        monitor.write(mobs[i])
        if mobLookupTable[tostring(yPos)] == nil then
            mobLookupTable[tostring(yPos)] = {}
            mobLookupTable[tostring(yPos)][0] = mobs[i]
        else
            mobLookupTable[tostring(yPos)][1] = mobs[i]
        end

        if yPos == 17 then
            xPos = xPos + 15
            yPos = 4
        else 
            yPos = yPos + 1
        end
        
        monitor.setCursorPos(xPos, yPos)
    end

    -- divider
    xPos = 38
    monitor.setTextColor(colors.gray)
    for i=3,17 do
        monitor.setCursorPos(xPos,i)
        monitor.write("|")
    end

    -- spawners
    monitor.setCursorPos(41,3)
    monitor.setTextColor(colors.orange)
    monitor.write("==== SPAWNER ====")
    monitor.setCursorPos(41,6)
    monitor.setTextColor(colors.black)
    monitor.write(" LEFT      RIGHT")

    -- confirm button
    setGoButtonEnabled(false)

    -- reset button
    monitor.setCursorPos(53,19)
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.green)
    monitor.write("[ RESET ]")

    -- currently spawning
    monitor.setCursorPos(41,13)
    monitor.setTextColor(colors.black)
    monitor.write("Currently Spawning:")
    monitor.setCursorPos(42,14)
    monitor.write("Left:  ")
    monitor.write(getCurrentlySpawning("left"))
    monitor.setCursorPos(42,15)
    monitor.write("Right: ")
    monitor.write(getCurrentlySpawning("right"))

end

function getCurrentlySpawning(side)
    if side == "left" then
        return "Skeleton"
    else
        return "Cow"
    end
end

-- get a list of all the mobs in nets in the chest to the right
function getMobsFromChest()
    local chest = peripheral.wrap("right")
    mobs = {}
    index = 0
    for i=1,27 do
        slot = chest.getStackInSlot(i)
        if slot then
            if slot.name == coal then
                -- do nothing, that's fuel
            elseif slot.name == "Wither Skeleton" then
                -- special case for wither skeleton
                -- since it shows up as "Skeleton"
                mobName = "Wither Skeleton"
                mobs[index] = cleanName(mobName)
                index = index + 1
            else
                mobName = slot.captured
                mobs[index] = cleanName(mobName)
                index = index + 1
            end
        end
    end
    table.sort(mobs, function(a, b) return a:upper() < b:upper() end)
    return mobs
end

-- return the better version of the name
function cleanName(name)
    if name == "CaveSpider" then
        return "Cave Spider"
    elseif name == "NetherOres.netherOresHellfish" then
        return "Hellfish"
    elseif name == "LavaSlime" then
        return "Magma Cube"
    elseif name == "MushroomCow" then
        return "Mooshroom"
    elseif name == "MineFactoryReloaded.mfrEntityPinkSlime" then
        return "Pink Slime"
    elseif name == "PigZombie" then
        return "Zombie Pigman"
    else 
        return name
    end
end

function reset()
    local s = "Resetting..."
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.black)
    monitor.clear()
    monitor.setCursorPos((w/2-#s/2)+1,h/2)
    monitor.write(s)
    main()
end

function monitorClicked(x,y)

    if x >= 3 and x<= 32 and y >= 4 and y <= 17 then -- clicked in the mob window
        local y_str = tostring(y)
        local mobName = nil

        if lastMobClicked ~= nil then
            monitor.setCursorPos(lastMobClickedCursorX, lastMobClickedCursorY)
            monitor.setBackgroundColor(colors.white)
            monitor.setTextColor(colors.black)
            monitor.write(lastMobClicked)
        end

        if x >= 3 and x <= 17 then    -- first column clicked
            mobName = mobLookupTable[y_str][0]
            if mobName then
                monitor.setCursorPos(3,y)
                lastMobClickedCursorX = 3
                lastMobClickedCursorY = y
                monitor.setBackgroundColor(colors.blue)
                monitor.setTextColor(colors.white)
                monitor.write(mobName)
                mobToSpawn = mobName
            end
        elseif x >= 18 and x <= 32 then     -- second column clicked
            mobName = mobLookupTable[y_str][1]
            if mobName then
                monitor.setCursorPos(18,y)
                lastMobClickedCursorX = 18
                lastMobClickedCursorY = y
                monitor.setBackgroundColor(colors.blue)
                monitor.setTextColor(colors.white)
                monitor.write(mobName)
                mobToSpawn = mobName
            end
        else 
            -- nothing
        end
        lastMobClicked = mobName
    
    elseif x >= 41 and x <= 55 and y == 6 then -- clicked in the spawner choice
        if x >= 41 and x <= 45 then -- left was clicked
            monitor.setTextColor(colors.white)
            monitor.setBackgroundColor(colors.blue)
            monitor.setCursorPos(41,5)
            monitor.write("      ")
            monitor.setCursorPos(41,6)
            monitor.write(" LEFT ")
            monitor.setCursorPos(41,7)
            monitor.write("      ")

            monitor.setTextColor(colors.black)
            monitor.setBackgroundColor(colors.white)
            monitor.setCursorPos(51,5)
            monitor.write("       ")
            monitor.setCursorPos(51,6)
            monitor.write(" RIGHT ")
            monitor.setCursorPos(51,7)
            monitor.write("       ")

            spawnerToSpawnIn = "left"
        elseif x >= 51 and x<= 56 then -- right was clicked
            monitor.setTextColor(colors.black)
            monitor.setBackgroundColor(colors.white)
            monitor.setCursorPos(41,5)
            monitor.write("      ")
            monitor.setCursorPos(41,6)
            monitor.write(" LEFT ")
            monitor.setCursorPos(41,7)
            monitor.write("      ")

            monitor.setTextColor(colors.white)
            monitor.setBackgroundColor(colors.blue)
            monitor.setCursorPos(51,5)
            monitor.write("       ")
            monitor.setCursorPos(51,6)
            monitor.write(" RIGHT ")
            monitor.setCursorPos(51,7)
            monitor.write("       ")

            spawnerToSpawnIn = "right"
        end

    elseif x > 40 and x < 47 and y > 8 and y < 12 then  -- GO button was clicked
      if mobToSpawn ~= nil and spawnerToSpawnIn ~= nil and goodToSpawn then
        spawn(mobToSpawn, spawnerToSpawnIn)
      end
    elseif x > 50 and y == 19 then -- reset was clicked
        reset()
    end

    if mobToSpawn ~= nil and spawnerToSpawnIn ~= nil then
        goodToSpawn = true
        setGoButtonEnabled(true)
    else
        goodToSpawn = false
        setGoButtonEnabled(false)
    end


end

function setGoButtonEnabled(b)
    if b then
        monitor.setBackgroundColor(colors.green)
    else 
        monitor.setBackgroundColor(colors.gray)
    end
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(41,9)
    monitor.write("      ")
    monitor.setCursorPos(41,10)
    monitor.write("  GO  ")
    monitor.setCursorPos(41,11)
    monitor.write("      ")
end

function spawn(mob, spawner)
  modem = peripheral.wrap("left")
  if spawner == "left" then
    modem.transmit(leftSpawnerFreq, leftSpawnerFreq, mob)
  elseif spawner == "right" then
    modem.transmit(rightSpawnerFreq, rightSpawnerFreq, mob)
  end
  reset()
end


-- MAIN PROGRAM ---------------------------------

function main()
  mobs = getMobsFromChest()
  setUpGUI(mobs)

  while true do
    event, side, x, y = os.pullEvent("monitor_touch")
    monitor.setCursorPos(1,1)
    monitor.setBackgroundColor(colors.white)
    monitor.setTextColor(colors.black)
    monitor.write("["..x..", "..y.."]  ")
    monitorClicked(x,y)
  end 
end

main()