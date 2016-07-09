local essid = nil
local password = nil

if (essid == nil or password == nil)
then
    print("no essid/password set in wifi-setup, wifi will be disabled")
    wifi.setmode(wifi.NULLMODE)
else
    print("connecting to "..essid)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(essid, password)
end