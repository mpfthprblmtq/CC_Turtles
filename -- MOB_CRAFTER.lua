-- MOB_CRAFTER

local inputChest = peripheral.wrap("bottom")
local outputChest = peripheral.wrap("top")

items = {
    "Bow",
    "Iron Shovel",
    "Iron Sword",
    "Leather Cap",
    "Leather Tunic",
    "Leather Pants",
    "Leather Boots",
    "Chain Helmet",
    "Chain Chestplate",
    "Chain Leggings",
    "Chain Boots",
    "Iron Helmet",
    "Iron Chestplate",
    "Iron Leggings",
    "Iron Boots",
    "Golden Helmet",
    "Golden Chestplate",
    "Golden Leggings",
    "Golden Boots"
}

if inputChest == nil and outputChest == nil then
    print("Chest configuration is invalid, exiting!")
    return
end

-- clear out inventory
turtle.select(1)
turtle.dropUp()
turtle.select(2)
turtle.dropUp()

while true do
    for _,item in ipairs(items) do 
        print("Searching for: "..item)

        local firstSlot = nil
        
        for i=1,108 do
            local slot = inputChest.getStackInSlot(i)
            if slot then
                if slot.name == item then
                    if firstSlot == nil then
                        -- found the first item the matches
                        firstSlot = i
                    else
                        -- found another item, let's go ahead and craft it
                        inputChest.pushItem("up", firstSlot, 1, 1)
                        inputChest.pushItem("up", i, 1, 2)
                        turtle.craft()
                        print("Crafted: "..item)
                        turtle.dropUp()

                        -- reset and continue
                        firstSlot = nil
                    end
                end
            end
        end
    end
end