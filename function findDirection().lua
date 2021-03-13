function findDirection()

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

  -- check which side has a successful pushitem, return the inverse
  if chest.pushItem("north", index) > 0 then return "south" 
  elseif chest.pushItem("east", index) > 0 then return "west"
  elseif chest.pushItem("south", index) > 0 then return "north"
  elseif chest.pushItem("west", index) > 0 then return "east"
  end

  -- put the item back
  turtle.drop()
end

print(findDirection())
