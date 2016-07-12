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

switch = require("two_states_switch")

local function on(level)
    --print("starting")
    light.print_file("hex.txt", 30, 
        function ()
            switch.as_off()
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