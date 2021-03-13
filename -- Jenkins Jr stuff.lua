-- Jenkins Jr stuff

-- Functions -------------------------------------------------------------------

function setUp()
    turtle.forward()
    t = peripheral.wrap("bottom")
    t.setFrequency("2")
    t.setAccess("private")
end

function tearDown()
    turtle.up()
    turtle.forward()
    t = peripheral.wrap("bottom")
    t.setAccess("public")
    t.digDown()
end

-- Begin Program ---------------------------------------------------------------

turtle.back()
local pipeIsThere = not turtle.down()
if pipeIsThere == false then
    setUp()
else 
    tearDown()
end
