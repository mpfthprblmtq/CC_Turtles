--[[
    File:           copy
    Created by:     mpfthprblmtq
    Last modified:  07/21/2020

    Prerequisites:
        A full mystcraft setup, which in my case is a desk with ink and paper flowing into it constantly
        A notebook placed in the writing desk, named "Dense Ore World Notebook" using an anvil
        In that notebook, in this order, the following pages:
            1. Stone Block
            2. Standard World
            3. Dense Ores
            4. Scorched Surface
        A turtle (Advanced or Regular, doesn't matter)
        This copy program installed (pastebin get PDLJP6Hk copy)
        The turtle placed above the writing desk's left slot (See note below)

        NOTE:   I made this program work by placing the turtle somewhere above the desk, then made him go to the desk,
                but you can edit it to do whatever you want, the movement code is in the function moveToDesk().
                You may also not need the fuel level check if you don't need it to move.
                If you don't want to worry about the turtle moving around, just edit the main program code to not call
                checkFuelLevel() and moveToDesk(), and place the turtle on the top of the writing desk's left block

    Directions:
        1. Run the copy program
        2. Follow the prompts the turtle gives you
        3. Constantly click on the copied page to bring it into your inventory
--]]

-- CONSTANTS ------------------------------------

-- wrap the desk
desk = peripheral.wrap("bottom")

-- wrap the fuel chest
fuelChest = peripheral.wrap("right")

-- minimum amount of fuel needed to perform the task
fuelThreshold = 80

-- slot constants
STONE_BLOCK_SLOT = 1
STANDARD_WORLD_SLOT = 2
DENSE_ORES_SLOT = 3
SCORCHED_SURFACE_SLOT = 4

DENSE_ORE_NOTEBOOK = "Dense Ore World Notebook"

-- FUNCTIONS ------------------------------------

-- checks the fuel level
-- if it is below the threshold, turn to the chest to the turtle's right, which
-- contains nothing but coal, and attempt to refuel
-- returns true if the refuel was successful
-- returns false if the refuel was not successful
function checkFuelLevel()
    local startingFuelLevel = turtle.getFuelLevel()
    if startingFuelLevel < fuelThreshold then
        print("Fuel level below threshold, refueling...")
        turtle.turnRight()
        turtle.suck()
        turtle.refuel()
        turtle.turnLeft()
    end

    local newFuelLevel = turtle.getFuelLevel()
    if newFuelLevel < fuelThreshold then
        print("Couldn't refuel, exiting!")
        return false
    else
        print("Refueled!")
        return true
    end
end

-- moves to the desk
function moveToDesk()
    turtle.forward()
    turtle.forward()
    turtle.down()

    -- re-wrap the desk
    desk = peripheral.wrap("bottom")
end

-- goes back to the starting position
function returnFromDesk()
    turtle.turnRight()
    turtle.turnRight()
    turtle.up()
    turtle.forward()
    turtle.forward()
    turtle.turnRight()
    turtle.turnRight()
end

-- find the dense ore world notebook in the desk
-- returns the slot of the notebook in the desk
-- (minus 4 because the first slot of notebooks is 5,
--  so the 5th slot is really the 1st, 6th is the 2nd, etc.)
-- returns -1 if the dense ore world notebook wasn't found
function findNotebook()
    print("Looking for the dense ore notebook...")

    -- traverse the desk's notebook slots and find it
    for i=5,29 do
        local slot = desk.getStackInSlot(i)
        if slot.name == DENSE_ORE_NOTEBOOK then
            return i - 4
        end
    end

    -- couldn't find it
    print("Couldn't find dense ore notebook!")
    return -1
end

-- gets the user's input
-- returns the number of dense ore pages if valid
-- returns -1 if input was invalid
function getUserInput()
    print("How many Dense Ore pages?")
    write("   : ")
    local input = read()

    -- validate user input (make sure it's an int)
    pageAmount = math.floor(input)
    if tostring(pageAmount) ~= input then
        print("Input not valid, exiting...")
        return -1
    else
        return pageAmount
    end 
end

-- function to actually copy the pages
-- params:
--      notebookSlot, the slot in the desk where the notebook is (minus 4, see the doc for findNotebook())
--      pageSlot, the slot in the notebook where the page is
--      amount, the amount of pages to copy
function copyPages(notebookSlot, pageSlot, amount)
    local pagesCount = 0
    local pagesAmountReached = false

    -- sit in a loop while we get the right amount of dense ore pages
    while not pagesAmountReached do
        -- write page
        desk.writeSymbol(notebookSlot, pageSlot)

        local pageTaken = false

        -- wait for the page to be taken
        while not pageTaken do
            if desk.getStackInSlot(1) then
                -- page is still there, stay in the loop
            else
                pageTaken = true   -- page is gone, leave loop and continue
            end
        end

        -- inc count
        pagesCount = pagesCount + 1

        -- check if done
        if pagesCount == amount then
            pagesAmountReached = true
        end
    end
end

-- MAIN PROGRAM ---------------------------------

-- check fuel level
if not checkFuelLevel() then
    return
end

-- go to the desk
moveToDesk()

-- find notebook
local notebookSlot = findNotebook()
if notebookSlot < 0 then
    return  -- wasn't found
end

-- get user input
local pageAmount = getUserInput()
if pageAmount < 0 then
    return  -- user input wasn't valid
end

-- copy stone and standard
write("Copying Stone/Standard pages...")
copyPages(notebookSlot, STONE_BLOCK_SLOT, 1)
copyPages(notebookSlot, STANDARD_WORLD_SLOT, 1)
print("Done")

-- copy dense ore pages
write("Copying Dense Ore pages...")
copyPages(notebookSlot, DENSE_ORES_SLOT, pageAmount)
print("Done")

-- copy scorched pages
write("Copying Scorched pages...")
copyPages(notebookSlot, SCORCHED_SURFACE_SLOT, pageAmount * 10)
print("Done")

-- go home
returnFromDesk()

-- END PROGRAM ----------------------------------