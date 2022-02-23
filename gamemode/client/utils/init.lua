BLAST.Group = ""
staff = false
dev = false

CreateThread(function()
    Server("PREFIX_PLACEHOLDER:Spawn", GetPlayerServerId(PlayerId()), GetPlayerName(PlayerId()))
    Server("PFE", "NetworkStartSession")
end)

CreateThread(function()
while true do
    Wait(1000)
    ClearPlayerWantedLevel(PlayerId())
    SetMaxWantedLevel(0)
end
end)

CreateThread(function()
    while true do 
    NetworkOverrideClockTime(6, 30, 00)
    SetWeatherTypePersist("EXTRASUNNY")
    SetWeatherTypeNowPersist("EXTRASUNNY")
    SetWeatherTypeNow("EXTRASUNNY")
    SetOverrideWeather("EXTRASUNNY")
    Wait(1000)
    end
end)

RegisterNetEvent("PREFIX_PLACEHOLDER:Initialize")
AddEventHandler("PREFIX_PLACEHOLDER:Initialize", function(name, serverId, group, Crew)
    BLAST.Group = group
    BLAST.Player.Crew = Crew

    if group == "dev" then
        DisplayNotif("~r~[" .. serverId .. "] " .. name .. " ~s~joined")
    end

    -- Todo: init group
    if group == "staff" then
        staff = true
    end
    if group == "dev" then
        dev = true
    end
    if group == "user" then
        staff = false
        dev = false
    end
end)