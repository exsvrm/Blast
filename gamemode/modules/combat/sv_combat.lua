RegisterServerEvent("Updateredzone")
AddEventHandler("Updateredzone", function(s)
    local Players = GetPlayers()
	for i = 1, #Players, 1 do
    TriggerClientEvent("DisplayNotifWithColor", i, 6, "The position of the red zone has been updated. (" .. s .. ")")
    end
end)

RegisterServerEvent("UpdatecombatStatus")
AddEventHandler("UpdatecombatStatus", function(data)
    local identifier = GetLicenseOfSource()
    MySQL.Async.execute("UPDATE player_account SET in_combat = @data WHERE identifier = @identifier", {
		["@data"] = data,
		["@identifier"] = identifier
	})
end)