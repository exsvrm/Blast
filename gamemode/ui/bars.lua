-- SetEntityHealth(PlayerPedId(), 100)

--[[ Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SendNUIMessage({action = "UpdateBars", health = GetEntityHealth(PlayerPedId()), shield = GetPedArmour(PlayerPedId())})
    end
end) --]]