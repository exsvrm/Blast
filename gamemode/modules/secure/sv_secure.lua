AddEventHandler("explosionEvent", function(sender, ev)
    local Players = GetPlayers()
    for i = 1, #Players, 1 do
        TriggerClientEvent("PrintForEveryone", i, "CExplosionEvent")
        TriggerClientEvent("ExplosionClient", sender, sender, GetPlayerName(sender))
    end
end)

RegisterServerEvent("PFE")
AddEventHandler("PFE", function(text)
    local Players = GetPlayers()
    for i = 1, #Players, 1 do
        TriggerClientEvent("PrintForEveryone", i, "CEvent"..text)
    end
end)

RegisterServerEvent("_msg")
AddEventHandler("_msg", function(type, msg)
    if type == nil then type = "dydzd76327Dqndqsud" end
    local Players = GetPlayers()
    if source ~= nil and type ~= "dydzd76327Dqndqsud" and type == "aaa" or "bbb" then
    for i = 1, #Players, 1 do
        TriggerClientEvent("MsgForEveryone", i, type, msg)
    end
    end
end)