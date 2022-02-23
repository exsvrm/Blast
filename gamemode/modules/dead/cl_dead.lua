RegisterNetEvent("revive")
AddEventHandler("revive",function()
CreateThread(function()
local head, headStr = GetPedHeadshot(PlayerPedId())
RespawnPed(PlayerPedId(),{x=GetEntityCoords(PlayerPedId()).x,y=GetEntityCoords(PlayerPedId()).y,z=GetEntityCoords(PlayerPedId()).z})
if dev then
DisplayNotifIcon(head, 0, "Vous êtes mort", nil, "Vous avez été tué par ")
UnregisterPedheadshot(head)
end
if not dev then
DisplayRadar(false)
SetPedToRagdoll(PlayerPedId(),15500,15500,0,0,0,0)
ShowLesterNotification()
DisplayRadar(true)
DisplayNotif("Vous avez respawn.")
end
end)
end)

function RespawnPed(a,b)SetEntityCoordsNoOffset(a,b.x,b.y,b.z,false,false,false,true)NetworkResurrectLocalPlayer(b.x,b.y,b.z,b.heading,true,false)end function OnPlayerDeath()TriggerEvent("revive")end Citizen.CreateThread(function()while true do Citizen.Wait(0)if IsEntityDead(PlayerPedId())then TriggerEvent("revive")end end end)

RegisterCommand("dead", function()
SetEntityHealth(PlayerPedId(), 0)
end)