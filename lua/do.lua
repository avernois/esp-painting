print(wifi.sta.getip())

local gpio_trig, gpio_read = gpio.trig, gpio.read

local data = 6
local clock = 7
local button = 1
local alarm = 0



if (server ~= nil)
then
    server.stop()
    server = nil
end
server = require("server")

server.start(8080, require("protocol"))

local light = require("light_paint")
light.init(data, clock, alarm)

gpio.mode(button, gpio.INPUT, gpio.PULLUP)


local function button_trigger_start()
    gpio_trig(button, "down", triggered_start)
end

local function button_trigger_stop()
    gpio_trig(button, "down", triggered_stop)
end


function triggered_stop(level)
    if (level == 0 and gpio_read(button) == 0)
    then
        print("stopping")
        light.stop(
            function () 
                light.off()
                button_trigger_start()
            end)
        
    end
end

function triggered_start(level)
    if (level == 0 and gpio_read(button) == 0)
    then
        print("starting")
        light.print_file("hex.txt", 30, 
            function () 
                light.off()
                button_trigger_start()
            end)
        button_trigger_stop()
    end 
end

button_trigger_start()

package.loaded["light_paint"] = nil
package.loaded["server"] = nil
package.loaded["protocol"] = nil