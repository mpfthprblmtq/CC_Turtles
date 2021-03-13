-- IMPORT

function getMob()
    shell.run("delete mob")
    shell.run("pastebin get 6wjYK3R2 mob")
end

function getMobClicker()
    shell.run("delete mob_clicker")
    shell.run("pastebin get AaZQccL9 mob_clicker")
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

-- BEGIN PROGRAM

local args = {...}
local input = args[1]

if input == nil then
    print("Which program would you like to download?")
    write("   :")
    input = read()
end

if input == "mob" then
    getMob()

elseif input == "mob_clicker" then
    getMobClicker()

elseif input == "refuel" then
    getRefuel()

elseif input == "fill" then
    getFill()

elseif input == "empty" then
    getEmpty()

elseif input == "quarry" then
    getQuarry()

elseif input == "configureTesseract" then
    getConfigureTesseract()

elseif input == "import" then
    getImport()

elseif input == "all" then
    getMob()
    getRefuel()
    getFill()
    getEmpty()
    getQuarry()
    getConfigureTesseract()
    getImport()

elseif input == "exit" then
    return

else
    print("Input not recognized, exiting...")
    return
end
