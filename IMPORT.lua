--[[
    File:           import
    Created by:     mpfthprblmtq
    Last modified:  07/21/2020

    Description:  This is just an import utility that I use to import all my code into turtles and computers
--]] 

-- FUNCTIONS ------------------------------------

function getMob()
    shell.run("delete mob")
    shell.run("pastebin get 6wjYK3R2 mob")
end

function getMobClicker()
    shell.run("delete mob_clicker")
    shell.run("pastebin get AaZQccL9 startup")
end

function getMobNode()
    shell.run("delete startup")
    shell.run("pastebin get qpJxdUbA startup")
end

function getRefuel()
    shell.run("delete refuel")
    shell.run("pastebin get wGCSXygM refuel")
end

function getFill()
    shell.run("delete fill")
    shell.run("pastebin get afTPaLmQ fill")
end

function getEmpty()
    shell.run("delete empty")
    shell.run("pastebin get EmKKTzRP empty")
end

function getCopy()
    shell.run("delete copy")
    shell.run("pastebin get PDLJP6Hk copy")
end

function getQuarry()
    shell.run("delete quarry")
    shell.run("pastebin get 9FHQjaAu quarry")
end

function getConfigureTesseract()
    shell.run("delete configureTesseract")
    shell.run("pastebin get GdiFzD6M configureTesseract")
end

function getImport()
    shell.run("delete import")
    shell.run("pastebin get 2RGVxSRM import")
end

-- MAIN PROGRAM ---------------------------------

-- allow the user to run the command "import refuel"
local args = {...}
local input = args[1]

-- if the user didn't provide a program as an argument, get user's input
if input == nil then
    print("Which program would you like to download?")
    write("   : ")
    input = read()
end

if input == "mob" then
    getMob()

elseif input == "mob_clicker" then
    getMobClicker()

elseif input == "mob_node" then
    getMobNode()

elseif input == "refuel" then
    getRefuel()

elseif input == "fill" then
    getFill()

elseif input == "empty" then
    getEmpty()

elseif input == "copy" then
    getCopy()

elseif input == "quarry" then
    getQuarry()

elseif input == "configureTesseract" then
    getConfigureTesseract()

elseif input == "import" then
    getImport()

elseif input == "all" then
    getMob()
    getMobClicker()
    getMobNode()
    getRefuel()
    getFill()
    getEmpty()
    getCopy()
    getQuarry()
    getConfigureTesseract()
    getImport()

elseif input == "exit" then
    return

else
    print("Input not recognized, exiting...")
    return
end
