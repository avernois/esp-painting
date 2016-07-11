local net = net
local file = file
local print = print

local M = {}
if setfenv then
    setfenv(1, M) -- for 5.1
else
    _ENV = M -- for 5.2
end

local server= nil

local protocol={}


local function serve(socket)
    socket:on("connection", function(socket)
        print("receive connection")
    end)
    socket:on("receive", protocol.receive)    

    socket:on("disconnection", protocol.disconnect)
end


function start(port, com_protocol)
    protocol = com_protocol
    server = net.createServer(net.TCP, 5)
    server:listen(port, serve)
    print("server created and listening on port: ".. port)
end

function stop()
    if (server ~=nil)
    then
        print("closing server")
        server:close()
    end
end

return M
