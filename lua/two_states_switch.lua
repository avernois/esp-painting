local gpio_mode, gpio_trig, gpio_read = gpio.mode, gpio.trig, gpio.read
local gpio_INPUT, gpio_PULLUP = gpio.INPUT, gpio.PULLUP
local print = print


local M = {}
if setfenv then
    setfenv(1, M) -- for 5.1
else
    _ENV = M -- for 5.2
end

local button = 1

local on = nil
local off = nil

local STATE_ON = "on"
local STATE_OFF = "off"

local current_state = STATE_OFF

local function trigger(level)
    if (level == 0 and gpio_read(button) == 0)
    then
        if (current_state == STATE_ON)
        then
            off(level)
            as_off()
        else
            on(level)
            as_on()
        end
    end 
end

function init(button_pin, on_callback, off_callback)
    button = button_pin or 1
    gpio_mode(button, gpio_INPUT, gpio_PULLUP)
    
    on = on_callback
    off = off_callback
    current_state = STATE_OFF
end

function activate()
    gpio_trig(button, "down", trigger)
end

function as_off()
    current_state = STATE_OFF
end

function as_on()
    current_state = STATE_ON
end



return M
