print(wifi.sta.getip())

local gpio_trig, gpio_read = gpio.trig, gpio.read

local data = 6
local clock = 7
local button = 1
local alarm = 0

local sda = 2
local scl = 5

local last_call = 0
local function debounced() {
    debounced = false
    if ((tmr.now() - last_call) > (500 * 1000)) then
        debounced = true
        last_call = tmr.now()
    end
    
    return debounced
}

if (server ~= nil)
then
    server.stop()
    server = nil
end
server = require("server")

server.start(8080, require("protocol"))


local screen = require("list_selection")
screen.init(sda, scl)

local selection = {}
local selected = 1

local function files_list()
    files = {}
    for file, _ in pairs(file.list()) do
        if(string.sub(file, -4) == ".txt") then
            table.insert(files, file)
        end
    end

    return files
end

selection = files_list()
screen.display(selection, selection[selected])

function select_up(level)
    if(not debounced()) then return end
    if(selected > 1) then
        selected = selected -1
    else
        selected = table.getn(selection)
    end
    screen.display(selection, selection[selected])
end


local button_up = 4
local button_down = 8

gpio.mode(button_up,   gpio.INPUT, gpio.PULLUP)
gpio.trig(button_up, "down", select_up)


local light = require("light_paint")
light.init(data, clock, alarm)

switch = require("two_states_switch")

delay = 30

local function on(level)
    --print("starting")
    light.print_file(selection[selected], delay, 
        function ()
            switch.as_off()
            light.off()
        end)
end

local function off(level)
    light.stop(
        function () 
            light.off()
        end)
end

switch.init(1, on, off)
switch.activate()


package.loaded["two_states_switch"] = nil
package.loaded["light_paint"] = nil
package.loaded["server"] = nil
package.loaded["protocol"] = nil
