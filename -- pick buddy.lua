-- pick buddy

local infuser = peripheral.wrap("top")
local activator = peripheral.wrap("bottom")

-- check to see if configuration is good
local shouldExit = false
if infuser == nil then
  print("Can't find Energetic Infuser above me!")
  shouldExit = true
end
if activator == nil then
  print("Can't find Autonomous Activator below me!")
  shouldExit = true
end
if shouldExit then
  return
end

term.clear()
term.setCursorPos(1,1)

print("Running...")
print("")

while true do
  local charge = activator.getStackInSlot(1).energyStored
  if charge < 1000 then
    print("Pick's charge is below 1,000!")
    print("Sending it up...")
    turtle.suckUp()
    turtle.dropUp()
    turtle.turnRight()
    print("Waiting for pick to come back from charging...")

    while true do
      if turtle.drop() then
        turtle.turnLeft()
        print("Pick sent back to Activator!")
        break
      end
    end
  end
end