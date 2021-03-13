-- Mob (OLD)

-- program for controlling multiple mob spawners

-- gets the net from the ME
function getNet (mob)
	print("Getting the net for "..mob.."...")

	-- get into position
	turtle.back()

	-- get the slot where the correct safari net is
	local slot = grabAndCheck(mob)
	print(mob.." found in slot "..slot..", grabbing...")
	
	-- actually grab it
	local chest = peripheral.wrap("bottom")
	chest.pushItem("up", slot, 1, 1)
	print("Got it!")
end

function grabAndCheck(mob)
	local chest = peripheral.wrap("bottom")
	for i=1,27 do
		local slot = chest.getStackInSlot(i)
		if slot.name == mob then
			return i
		end
	end
	print(mob.." wasn't found!")
	os.exit()
end

function goToSpawner(spawner)
	print("Going to "..spawner.." spawner...")
	turtle.back();
	for i=1,6 do
		turtle.down()
	end
	for i=1,7 do
		turtle.forward()
	end

	if spawner == "left" then
		turtle.turnLeft()
		for i=1,6 do
			turtle.forward()
		end
		turtle.turnRight()
		for i=1,6 do
			turtle.forward()
		end
		for i=1,3 do
			turtle.up()
		end
		turtle.turnRight()
		turtle.forward()
		turtle.turnRight()
		turtle.forward()
		print("Arrived at "..spawner.." spawner.")
	end
end

function replaceNet()
	local spawner = peripheral.wrap("top")
	if isEmpty(spawner.getStackInSlot(1)) then
		-- no net in there
	else
		spawner.pushItem("down", 1, 1, 2)
	end
	
	-- put the new net in the spawner
	turtle.dropUp(1)
end

function goBackToBase(spawner)
	if spawner == "left" then
		turnLeft(2)
		goForward(1)
		turnLeft(1)
		goForward(1)
		turnLeft(1)
		goDown(2)
		goForward(6)
		turnLeft(1)
		goForward(6)
		turnRight(1)
		goForward(7)
		goUp(6)
		turnRight(2)
		goForward(1)
		returnNet()
		goForward(1)
	end
end

function returnNet()
	turtle.select(2)
	turtle.dropDown(1)
end

function isEmpty(s)
  return s == nil or s == ''
end

function goForward(n)
	for i=1,n do
		turtle.forward()
	end
end

function goBack(n)
	for i=1,n do
		turtle.back()
	end
end

function goUp(n)
	for i=1,n do
		turtle.up()
	end
end

function goDown(n)
	for i=1,n do
		turtle.down()
	end
end

function turnLeft(n)
	for i=1,n do
		turtle.turnLeft()
	end
end

function turnRight(n)
	for i=1,n do
		turtle.turnRight()
	end
end

-- usage ex: > mob pig left
local args = {...}
local mob = args[1]
local spawner = args[2]
print("Spawning "..mob.." in "..spawner.." spawner")

getNet(mob)
goToSpawner(spawner)
replaceNet()
goBackToBase(spawner)

-- reset
turtle.select(1)