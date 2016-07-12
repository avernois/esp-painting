local apawrite = apa102.write
local file_readline, file_open, file_close = file.readline, file.open, file.close
local fromHex = encoder.fromHex
local string_gsub, string_char, string_rep, string_len = string.gsub, string.char, string.rep, string.len
local tmr = tmr

local print = print 
local gpio_read, gpio_trig, gpio_mode, gpio_OUTPUT = gpio.read, gpio.trig, gpio.mode, gpio.OUTPUT

local M = {}
if setfenv then
    setfenv(1, M) -- for 5.1
else
    _ENV = M -- for 5.2
end

local data = 6
local clock = 7
local alarm = 0

local callback = nil

function off()
    leds_abgr = string_rep(string_char(0, 0, 0, 0), 112)
    apawrite(data, clock, leds_abgr)
end

local function read_line()       
    line = file_readline()
    if(line ~= nil and string_len(line) == 1024)
    then
        line = line..file_readline()
    end
    return line
end

local function print_line(line)
    hex = fromHex(line)
    apawrite(data, clock, hex)
end

local function print_frame()
    line = read_line()
    if (line ~= nil)
    then
        line = string_gsub(line, "\n", "")    
        print_line(line)
     else
        stop(callback)
     end
end

function init(data_pin, clock_pin, alarm_id)
    data = data_pin
    clock = clock_pin
    alarm = alarm_id
    gpio_mode(data, gpio_OUTPUT) 
    gpio_mode(clock, gpio_OUTPUT)

    off()
end

function print_file(filename, delay, end_callback)
    callback= end_callback or off
    ret = file_open(filename, "r")
    if(not ret)
    then
        error("can't open file named: "..filename)
    end
    tmr.alarm(alarm, delay, tmr.ALARM_AUTO, print_frame)
    current = 1
end

function stop(end_callback)
    file_close()
    tmr.stop(alarm)
    if (end_callback ~= nil)
    then
        end_callback()
    else
        off()
    end
end

return M
