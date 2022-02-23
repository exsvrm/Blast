BLAST.Base.Coords = vec3(-468.347931, -925.757202, 23.683842)

BLAST.Base.Inbase = false

function BLAST.Base:Blip()
    local blip = AddBlipForRadius(BLAST.Base.Coords, 135.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 2)
    SetBlipAlpha(blip, 128)
    local blip = AddBlipForCoord(BLAST.Base.Coords)
    SetBlipHighDetail(blip, true)
    SetBlipSprite(blip, 557)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    SetBlipDisplay(blip, 3)
  
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Base")
    EndTextCommandSetBlipName(blip)
end

AddEventHandler("playerSpawned", function()
    SetEntityCoords(PlayerPedId(), -450.396881, -923.834656, 29.392803)
    if dev then
        SetEntityCoords(PlayerPedId(), 2799.529, -3930.539, 184.000)
    end
end)

RegisterCommand("gotobase", function()
if staff or dev then
    SetEntityCoords(PlayerPedId(), -450.396881, -923.834656, 29.392803)
end
end)

CreateThread(function()
    -- Base
    BLAST.Base:Blip()

    while true do
    Wait(1)

    local dist = #(BLAST.Base.Coords - GetEntityCoords(PlayerPedId()))
    
    if dist <= 135 then
        if not BLAST.Base.Inbase then
        NetworkSetFriendlyFireOption(true)
        DisplayNotif("Vous êtes désormais dans la base")
        BLAST.Base.Inbase = true
        end
    end

    if dist >= 135 then
        if BLAST.Base.Inbase then
        NetworkSetFriendlyFireOption(false)
        DisplayNotif("Vous n'êtes plus dans la base")
        BLAST.Base.Inbase = false
        end
    end

end
end)