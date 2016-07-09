data = 6
clock = 7

button = 1

gpio.mode(data, gpio.OUTPUT) 
gpio.mode(clock, gpio.OUTPUT)
gpio.mode(button, gpio.INPUT, gpio.PULLUP)

local apawrite = apa102.write
local readline = file.readline
local fromHex = encoder.fromHex
local gsub = string.gsub

function off()
    leds_abgr = string.char(0, 0, 0, 0)
    leds_abgr = string.rep(leds_abgr, 112)
    apawrite(data, clock, leds_abgr)
end

local function read_line()       
    line = readline()
    if(line ~= nil and string.len(line) == 1024)
    then
        line = line..readline()
    end
    return line
end

local function print_line(line)
    hex = fromHex(line)
    apawrite(data, clock, hex)
end

local delay = 40

function print_frame()
    line = read_line()
    if (line ~= nil)
    then
        line = gsub(line, "\n", "")    
        print_line(line)
     else
        print("line is nil, close file")
        file.close()
        gpio.trig(button, "down" or "up", trigger)
        stop()
        --start(delay)
     end
end

function stop()
    print("stop tmr 0")
    tmr.stop(0)
    off()
end


function start(delay)
    off()
    file.open("hex.txt", "r")
    tmr.alarm(0, delay, tmr.ALARM_AUTO, print_frame)
   
    current = 1
end


function triggered_stop(level)
    if (level == 0 and gpio.read(button) == 0)
    then
        print("stopping")
        stop()
        gpio.trig(button, "down" or "up", trigger)
    else
        print("triggereds with", level, gpio.read(button))
    end
    
end


function trigger(level)
    --gpio.trig(button, "down" or "up", stop)
    if (level == 0 and gpio.read(button) == 0)
    then
        print("starting")
        start(delay)
        gpio.trig(button, "down" or "up", triggered_stop)
    else
        print("triggereds with", level, gpio.read(button))
    end
    
end

gpio.trig(button, "down" or "up", trigger)

