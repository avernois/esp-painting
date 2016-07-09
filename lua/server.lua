if (server ~=nil)
then
    print("closing server")
    server:close()
end

line = 0


server = net.createServer(net.TCP, 5)
print("server created", server)
function serve(socket)
    socket:on("connection", function(socket)
        print("receive connection")
    end)
    socket:on("receive", function (socket, payload)
        if (payload == "clean")
        then
            file.remove("hex.txt")
            print("clean file")
        else 
            file.open("hex.txt", "a+")
            file.write(payload)
            file.close()
        end
    end)    

    socket:on("disconnection", function (socket)
        print("disconnected, closing file")
        file.close()
    end)
end


server:listen(8080, serve)

print(wifi.sta.getip())


