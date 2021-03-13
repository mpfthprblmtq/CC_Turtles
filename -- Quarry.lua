-- Quarry

-- Constants -------------------------------------------------------------------
 
dirt = "Dirt"
dirtSlot = 1
activator = "Autonomous Activator"
activatorSlot = 2
landmark = "tile.markerBlock"
landmarkSlot = 3
quarry = "tile.machineBlock" -- odd name for quarry
quarrySlot = 4
conduit = "Redstone Energy Conduit"
conduitSlot = 5
tesseract = "Tesseract"
tesseractSlot = 6
pipe = "item.PipeItemsCobblestone"
pipeSlot = 7
jenkinsJr = "Advanced Engineering Turtle"
jenkinsJrSlot = 8
enderChest = "Ender Chest"

fuelThreshold = 200
masterChest = nil
fuelChest = nil
                                                                               
-- Functions -------------------------------------------------------------------

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

-- finds the direction the turtle is facing
function findDirectionTurtleIsFacing()

  chest = peripheral.wrap("front")

  -- make sure chest has something in it
  local index = 0
  for i = 1, chest.getInventorySize() do
    slot = chest.getStackInSlot(i)
    if slot then
      index = i
      break
    end
  end
  if index == 0 then return "" end

  local direction = nil

  -- check which side has a successful pushitem, return the inverse
  if chest.pushItem("north", index) > 0 then direction = "south" 
  elseif chest.pushItem("east", index) > 0 then direction = "west"
  elseif chest.pushItem("south", index) > 0 then direction = "north"
  elseif chest.pushItem("west", index) > 0 then direction = "east"
  end

  -- put the item back
  turtle.drop()

  -- return the result
  return direction
end

-- inverts the direction
function invertDirection(direction)
  if direction == "north" then return "south"
  elseif direction == "south" then return "north"
  elseif direction == "east" then return "west"
  elseif direction == "west" then return "east"
  else return ""
  end
end

-- ensures turtle has fuel
-- assumes that the master chest is in front of the turtle
function checkFuelLevel()
  local startingFuelLevel = turtle.getFuelLevel()
  if startingFuelLevel < fuelThreshold then
    print("Fuel level below threshold ("..fuelThreshold.."), refueling!")
    turtleFacing = findDirectionTurtleIsFacing()
    pushDirection = invertDirection(turtleFacing)
    print("Turtle is facing "..turtleFacing..", pushing to the "..pushDirection)
    local index = nil
    for i=1,27 do
      local slot = masterChest.getStackInSlot(i)
      if slot then
        if slot.name == "Ender Chest" then
          if slot.dmg == 4095 then -- 4095 is the color code for black black black
            index = i
            break
          end
        end
      end
    end

    -- if index is still nil, fuel chest wasn't in master chest
    if index == nil then
      print("Couldn't find the fuel ender chest!")
      return false
    end

    -- push the chest into the turtle's inventory
    masterChest.pushItem(pushDirection, index)

    -- configure fuel chest
    turtle.placeUp()
    fuelChest = peripheral.wrap("top")

    -- grab a stack of coal and refuel
    turtle.suckUp()
    turtle.refuel()

    -- break the chest and put it back into the master chest
    turtle.digUp()
    turtle.drop()

    -- if fuel level is still lower, refuel wasn't successful
    local newFuelLevel = turtle.getFuelLevel()
    if (newFuelLevel < fuelThreshold) then
      print("Refuel unsuccessful!")
      return false
    end
    print("Refuel successful!")
  end

  return true
end

-- places the chest in front of the turtle, make sure it's in the first slot
function placeChest()
    turtle.select(1)
    turtle.place()
    masterChest = peripheral.wrap("front")
    if masterChest == nil then
        print("No ender chest found in front of me, exiting...")
    end
end

-- empties all contents of turtle into chest in front of it
function emptyIntoChestAndExit()
    local enderChest = peripheral.wrap("front")
    if enderChest == nil then
        print("No ender chest found in front of me, exiting...")
        return false
    end

    for i=1,16 do
        turtle.select(i)
        turtle.drop()
    end

  turtle.select(1)
  turtle.dig()
  return true
end

-- gets all the required materials from the chest
function getStuffFromChest()
    getDirt()
    getActivator()
    getLandmarks()
    getQuarry()
    getConduit()
    getTesseract()
    getPipe()
    getJenkinsJr()
end

function getDirt()
    local enderChest = peripheral.wrap("bottom")
    if enderChest == nil then
        print("No ender chest found below me, exiting...")
    end

    local dirtFound = false;
    for i=1,27 do
        local slot = enderChest.getStackInSlot(i)
        if slot then
            if slot.name == dirt then
                enderChest.pushItem("up", i, 64, dirtSlot)
                dirtFound = true
                break
            end
        end
    end
    if dirtFound == false then
        print("Couldn't find any dirt, exiting...")
        emptyIntoChestAndExit("bottom")
    end
end

function getActivator()
    local enderChest = peripheral.wrap("bottom")
    if enderChest == nil then
        print("No ender chest found below me, exiting...")
    end
    
    local activatorFound = false;
    for i=1,27 do
        local slot = enderChest.getStackInSlot(i)
        if slot then
            if slot.name == activator then
                enderChest.pushItem("up", i, 2, activatorSlot)
                activatorFound = true
                break
            end
        end
    end
    if activatorFound == false then
        print("Couldn't find an activator, exiting...")
        emptyIntoChestAndExit("bottom")
    end
end

function getLandmarks()
    local enderChest = peripheral.wrap("bottom")
    if enderChest == nil then
        print("No ender chest found below me, exiting...")
    end
    
    local landmarksFound = false;
    for i=1,27 do
        local slot = enderChest.getStackInSlot(i)
        if slot then
            if slot.name == landmark then
                enderChest.pushItem("up", i, 3, landmarkSlot)
                landmarksFound = true
                break
            end
        end
    end
    if landmarksFound == false then
        print("Couldn't find any landmarks, exiting...")
        emptyIntoChestAndExit("bottom")
    end
end

function getQuarry()
    local enderChest = peripheral.wrap("bottom")
    if enderChest == nil then
        print("No ender chest found below me, exiting...")
    end
    
    local quarryFound = false;
    for i=1,27 do
        local slot = enderChest.getStackInSlot(i)
        if slot then
            if slot.name == quarry then
                enderChest.pushItem("up", i, 1, quarrySlot)
                quarryFound = true
                break
            end
        end
    end
    if quarryFound == false then
        print("Couldn't find a quarry, exiting...")
        emptyIntoChestAndExit("bottom")
    end
end

function getConduit()
    local enderChest = peripheral.wrap("bottom")
    if enderChest == nil then
        print("No ender chest found below me, exiting...")
    end
    
    local conduitFound = false;
    for i=1,27 do
        local slot = enderChest.getStackInSlot(i)
        if slot then
            if slot.name == conduit then
                enderChest.pushItem("up", i, 1, conduitSlot)
                conduitFound = true
                break
            end
        end
    end
    if conduitFound == false then
        print("Couldn't find any conduit, exiting...")
        emptyIntoChestAndExit("bottom")
    end
end

function getTesseract()
    local enderChest = peripheral.wrap("bottom")
    if enderChest == nil then
        print("No ender chest found below me, exiting...")
    end
    
    local tesseractFound = false;
    for i=1,27 do
        local slot = enderChest.getStackInSlot(i)
        if slot then
            if slot.name == tesseract then
                enderChest.pushItem("up", i, 1, tesseractSlot)
                tesseractFound = true
                break
            end
        end
    end
    if tesseractFound == false then
        print("Couldn't find a tesseract, exiting...")
        emptyIntoChestAndExit("bottom")
    end
end

function getPipe()
    local enderChest = peripheral.wrap("bottom")
    if enderChest == nil then
        print("No ender chest found below me, exiting...")
    end
    
    local pipeFound = false;
    for i=1,27 do
        local slot = enderChest.getStackInSlot(i)
        if slot then
            if slot.name == pipe then
                enderChest.pushItem("up", i, 1, pipeSlot) -- hehe
                pipeFound = true
                break
            end
        end
    end
    if pipeFound == false then
        print("Couldn't find any pipes, exiting...")
        emptyIntoChestAndExit("bottom")
    end
end

function getJenkinsJr()
    local enderChest = peripheral.wrap("bottom")
    if enderChest == nil then
        print("No ender chest found below me, exiting...")
    end
    
    local jenkinsJrFound = false;
    for i=1,27 do
        local slot = enderChest.getStackInSlot(i)
        if slot then
            if slot.name == jenkinsJr then
                enderChest.pushItem("up", i, 1, jenkinsJrSlot)
                jenkinsJrFound = true
                break
            end
        end
    end
    if jenkinsJrFound == false then
        print("Couldn't find Jenkins Jr, exiting...")
        emptyIntoChestAndExit("bottom")
    end
end

function setUp()
    -- get user input for building an umbrella or not
    local buildRoof = false;
    print("Build an umbrella? (Y/N)")
    write("    : ")
    local input = read()

    if input == "y" or input == "Y" then
        buildRoof = true
    elseif input == "n" or "N" then
        -- do nothing, buildRoof is already initialized as false
    else 
        print("Input not recognized, exiting...")
        return false
    end

    -- place the chest
    placeChest()

    -- check fuel level, if it returns false, quit execution
    if not checkFuelLevel() then
      emptyIntoChestAndExit()
      return false
    end

    -- get above the chest
    turtle.up()
    turtle.forward()

    -- get all the stuff from the chest
    getStuffFromChest()

    -- start placing and moving and grooving
    back()
    turtle.select(activatorSlot)
    turtle.place()
    up()
    forward(2)
    down()
    forward(28)
    turtle.select(dirtSlot)
    turtle.place()
    up()
    turtle.select(landmarkSlot)
    turtle.place()
    right(2)
    down()
    forward(28)
    up()
    forward()
    left()
    forward()
    down()
    forward(29)
    turtle.select(dirtSlot)
    turtle.place()
    up()
    turtle.select(landmarkSlot)
    turtle.place()
    right(2)
    down()
    forward(29)
    up()
    turtle.select(landmarkSlot)
    turtle.place()
    left()
    forward(2)
    left(2)
    turtle.select(conduitSlot)
    turtle.place()
    left()
    forward()
    right()
    turtle.select(quarrySlot)
    turtle.place()
    up()
    turtle.select(pipeSlot)
    turtle.place()
    up()
    forward()
    right()
    forward()
    turtle.select(tesseractSlot)
    turtle.placeDown()
    forward(2)
    left(2)
    turtle.select(activatorSlot)
    turtle.place()
    up()
    forward(2)
    left(2)
    turtle.select(jenkinsJrSlot)
    turtle.placeDown()
    os.sleep(5) -- Jenkins Jr does his thing
    turtle.digDown()

    if buildRoof == true then
        roof()
    else
        right(2)
    end

    forward()
    left()
    forward()
    left(2)
    down(5)
    forward()
end

function roof()
    turtle.select(dirtSlot)
    forward(2)
    right()
    forward()
    right()
    up(3)
    forward()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    right()
    forward()
    right()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    left()
    forward()
    left()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    right()
    forward()
    right()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    forward()
    turtle.placeDown()
    forward()
    turtle.down()
    right()
    forward(2)
    right()
    down()
    forward()
    down()
    forward()
end

function tearDown()
    up()
    turtle.dig()    -- activator
    turtle.digUp()  -- quarry
    up()
    turtle.digUp()  -- pipe
    right()
    turtle.dig()    -- conduit
    up(3)
    forward()
    turtle.select(jenkinsJrSlot)
    turtle.placeDown()  -- placing Jenkins Jr to grab tessy
    os.sleep(5) -- take a nap
    turtle.suckDown()   -- suck the tessy out of Jenkins Jr
    turtle.digDown()    -- pick up Jenkins Jr
    forward()
    turtle.digDown()    -- activator
    right(2)
    forward(2)
    right()
    down(6)

    emptyIntoChestAndExit()
end

-- Begin Program ---------------------------------------------------------------

-- get user input for setup or tear down
print("Set up or tear down?")
print("  1) Set up")
print("  2) Tear down")
write("    : ")
local input = read()

if input == "1" then
  if setUp() then
    -- setup was successful
  else
    return
  end

elseif input == "2" then
  if tearDown() then
    -- teardown was successful
  else
    return
  end

else 
  print("Input not recognized, exiting...")
  return
end