--[[
    File:           counter_control
    Created by:     mpfthprblmtq
    Last modified:  11/20/2020
 
    Description:    Control terminal code to run the counter program
--]]

-- CONSTANTS/GLOBALS ----------------------------

turtleControlChannel = 101
screenControlChannel = 102

modem = peripheral.wrap("top")
modem.open(turtleControlChannel)
modem.open(screenControlChannel)

local exitFlag = false

-------------------------------------------------
 
-- FUNCTIONS ------------------------------------

-- send a message to the main control unit
function transmit(msg, channel)
  if modem ~= nil then
      modem.transmit(channel, channel, msg)
  end
end

-- resets the terminal to the startup screen
function reset()
  term.clear()
  term.setCursorPos(1,1)
  print("Welcome to the Counter Control Panel!")
  print("Input a command to execute:")
  print(" > ")
  term.setCursorPos(4,3)
  awaitCommand()
end

-- sits and waits for command from user
function awaitCommand()
  if exitFlag then
    term.setTextColor(colors.red)
    print("Exiting...")
    term.setTextColor(colors.white)
    print("")
    return
  else
    local input = read()
    parseCommand(input)
  end
end

function printHelp()
  term.clear()
  term.setCursorPos(1,1)
  print("Counter Control commands:")
  print("")
  print(" clear:  Clears this screen")
  print(" start:  Starts the counting")
  print(" reset:  Resets the counting screen,")
  print("         setting all values back to 0")
  print(" stop:   Stops all processes and shuts")
  print("         everything off")
  print(" exit:   Exits this program")
  print(" help:   How did we get here?")
  print("")
  print("Input a command to execute:")
  term.write(" > ")
  awaitCommand()
end

function messageAckd(channel) 
  local timout = os.startTimer(10)
  while true do
    local event, modemSide, sendChannel, replyChannel, message = os.pullEvent()
    if event == "timer" then
      return false
    elseif event == "modem_message" then
      if message == "ACK" and sendChannel == channel then
        return true
      else
        print(message)
        return false
      end
    end
  end
end

function start()
  print("Transmitting message to turtle to begin...")
  transmit("start", turtleControlChannel)
  if messageAckd(turtleControlChannel) then
    print("   ...Ack'd!")
  else
    print("   ...No response from turtle!")
  end
  print("Transmitting message to screen to begin...")
  transmit("start", screenControlChannel)
  if messageAckd(screenControlChannel) then
    print("   ...Ack'd!")
  else
    print("   ...No response from screen!")
  end
end

function resetCounterScreen()
  -- transmit message to screen to reset
  print("Transmitting message to screen to reset...")
  transmit("reset", screenControlChannel)
  if messageAckd(screenControlchannel) then
    print("   ...Ack'd!")
  else
    print("   ...No response from screen!")
  end
end

function stop()
  print("Transmitting message to turtle to stop...")
  transmit("stop", turtleControlChannel)
  if messageAckd(turtleControlChannel) then
    print("   ...Ack'd!")
  else
    print("   ...No response from turtle!")
  end
  print("Transmitting message to screen to stop...")
  transmit("stop", screenControlChannel)
  if messageAckd(screenControlChannel) then
    print("   ...Ack'd!")
  else
    print("   ...No response from screen!")
  end
end

-- parses the command given by the user
function parseCommand(input)

  local input = string.lower(input) -- lowercase it

  if input == "clear" then
    reset() -- reset the screen
  elseif input == "start" then
    start() -- start the counter process
  elseif input == "reset" then
    resetCounterScreen()  -- resets the screen, setting all values back to 0
  elseif input == "stop" then
    -- stop all processes
    stop()
  elseif input == "exit" then
    -- exits this program
    exitFlag = true
  elseif input == "help" then
    printHelp()
  else
    -- unknown input
    print("Unknown command!")
    print("Use \"help\" for a list of commands.")
  end

  if exitFlag then
    return
  else
    term.write(" > ")
    awaitCommand()
  end
end

-------------------------------------------------

-- MAIN PROGRAM ---------------------------------

reset()
awaitCommand()

-------------------------------------------------