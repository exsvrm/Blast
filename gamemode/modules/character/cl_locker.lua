BLAST.Locker.Coords = vec3(-452.465790, -932.900818, 29.392788)

function BLAST.Locker:Blip(Data)
    blip = AddBlipForCoord(self.Coords)
    SetBlipHighDetail(blip, true)
    SetBlipSprite(blip, Data.s)
    SetBlipScale(blip, Data.s2)
    SetBlipColour(blip, Data.c)
    SetBlipAsShortRange(blip, true)
    SetBlipDisplay(blip, 9)
  
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Locker")
    EndTextCommandSetBlipName(blip)
end

CreateThread(function()
    -- Locker
    BLAST.Locker:Blip({
        c = 4,
        s = 568,
        s2 = 1.0
    })
    while true do
        local dist = #(BLAST.Locker.Coords - GetEntityCoords(PlayerPedId()))
        if dist <= 1 then
            DisplayHelpNotif("~HUD_COLOUR_BLUELIGHT~Press ~INPUT_CONTEXT~ for access to ~b~locker~HUD_COLOUR_BLUELIGHT~.")
        end
        Wait(1)
    end
end)

CreateThread(function()
    while true do
        local dist = #(BLAST.Locker.Coords - GetEntityCoords(PlayerPedId()))
        if dist <= 3 then
            if IsControlJustPressed(0, 51) then
                -- SetNuiFocus(true, true)
                -- SendNUIMessage({action = "displayLocker"})
            end
        end
        Wait(1)
    end
end)