dofile("wifi-setup.lua")

function startup()
    if abort == true then
        print('startup aborted')
        return
        end
    print('in startup')
    dofile("main.lua")
    end

abort = false

tmr.alarm(0,5000,0,startup)
