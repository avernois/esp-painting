print(wifi.sta.getip())

local gpio_trig, gpio_read = gpio.trig, gpio.read

local data = 6
local clock = 7
local button = 1
local alarm = 0

local protocol = require("protocol")
local server = require("server")

server.start(8080, protocol)

local light = require("light_paint")
light.init(data, clock, alarm)

gpio.mode(button, gpio.INPUT, gpio.PULLUP)
function triggered_stop(level)
    if (level == 0 and gpio_read(button) == 0)
    then
        print("stopping")
        light.stop()
        gpio_trig(button, "down" or "up", triggered_start)
    end
end

function triggered_start(level)
    if (level == 0 and gpio_read(button) == 0)
    then
        print("starting")
        light.print_file("hex.txt", 30)
        gpio_trig(button, "down" or "up", triggered_stop)
    end 
end

gpio_trig(button, "down" or "up", triggered_start)

light_paint=nil
package.loaded["light_paint"] = nil
server = nil
package.loaded["server"] = nil
package.loaded["protocol"] = nil
protocol=nil