-- getStackInSlot(1) = copied page
-- getStackInSlot(2) = paper
-- getStackInSlot(3) = Ink Vial
-- getStackInSlot(4) = Glass Bottle

-- getStacKinSlot(5-29) = Notebook


-- ComputerCraft 1.58
-- OpenPeripherals 0.3.3

os.load("rom/apis/peripheral")



-- THIS WORKS, kinda

pushNotebookPage(deskSlot,direction,fromSlot,intoSlot?)
desk.pushNotebookPage(1,"west",1)
