PlayersData = {}
PlayersData.group = ""

function GetPlayerInfo(id)
    local i = id

    PlayersData[id] = {ServerID = id}

    local info = MySQL.Sync.fetchAll("SELECT * FROM player_account WHERE identifier = @identifier", {
        ['@identifier'] = GetLicense(id)
    })

    local info_crew = MySQL.Sync.fetchAll("SELECT * FROM crews")

    PlayersData.group = info[1].group

    PlayersData.crew = info[1].crew

    return PlayersData
end

RegisterServerEvent("DropSelf")
AddEventHandler("DropSelf", function(r)
    DropPlayer(source, r)
end)

RegisterServerEvent("AddMoney")
AddEventHandler("AddMoney", function(actual, new)
    local money = actual + new
    local identifier = GetLicenseOfSource()
    MySQL.Async.execute("UPDATE player_account SET money_cash = @money_cash WHERE identifier = @identifier", {
		["@money_cash"] = money,
		["@identifier"] = identifier
	})
end)


RegisterServerEvent("PREFIX_PLACEHOLDER:Spawn")
AddEventHandler("PREFIX_PLACEHOLDER:Spawn", function(id, name)
    local source = id
    local Player = GetPlayerInfo(source)
    TriggerClientEvent("PREFIX_PLACEHOLDER:Initialize", source, name, id, Player.group, Player.crew)
    TriggerClientEvent("admin:SetPlayer", source, "220", "none")
end)

RegisterServerEvent("Ban")
AddEventHandler("Ban", function()
    DropPlayer(source, "You are a cheater!\nBan expiration : 1 - 12 - 9850")
end)