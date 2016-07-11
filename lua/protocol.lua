local file = file
local print = print

local M = {}
if setfenv then
    setfenv(1, M) -- for 5.1
else
    _ENV = M -- for 5.2
end

local protocol={}

function receive(socket, payload)
        if (payload == "clean")
        then
            file.remove("hex.txt")
            print("clean file")
        else 
            file.open("hex.txt", "a+")
            file.write(payload)
            file.close()
        end
end

function disconnect(socket)
    print("disconnected, closing file")
    file.close()
end


return M
