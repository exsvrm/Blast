local callbackDebug = true
ServerCallbacks = {}
mygroup = "user"
 
function RegisterServerCallback(name, cb)
    ServerCallbacks[name] = cb
end

function Tsc(name, requestId, source, cb, ...)
    if ServerCallbacks[name] then
		ServerCallbacks[name](source, cb, ...)
	else
		print(("Erreur: callback inconnu."):format(name))
	end
end


RegisterServerEvent("Tsc")
AddEventHandler("Tsc", function(name, requestId, ...)
	local playerId = source
	Tsc(name, requestId, playerId, function(...)
		TriggerClientEvent("serverCallback", playerId, requestId, ...)
	end, ...)
end)

-- Callback

RegisterServerCallback("GetActivePlayers",function(source,cb)
    local playerlist = {}
    for _,v in pairs(GetPlayers()) do
        table.insert(playerlist, {
            name = GetPlayerName(v),
            id = v
        })
    end
    cb(playerlist or {})
end)

RegisterServerCallback("IsNew", function(source, cb)
	local identifier = GetLicense(source)

	MySQL.Async.fetchScalar("SELECT firstspawn FROM player_account WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(vip)
		cb(vip)
	end)
end)

RegisterServerCallback("GetStaff", function(source, cb)
	local identifier = GetLicense(source)

	MySQL.Async.fetchScalar("SELECT staff FROM player_account WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(bstaff)
		cb(bstaff)
	end)
end)

RegisterServerCallback("GetOwner", function(source, cb)
	local identifier = GetLicense(source)

	MySQL.Async.fetchScalar("SELECT owner FROM player_account WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(owner)
		cb(owner)
	end)
end)

RegisterServerCallback("GetVIP", function(source, cb)
	local identifier = GetLicense(source)

	MySQL.Async.fetchScalar("SELECT vip FROM player_account WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(vip)
		cb(vip)
	end)
end)

RegisterServerCallback("GetUuid", function(source, cb)
	local identifier = GetLicense(source)

	MySQL.Async.fetchScalar("SELECT uuid FROM player_account WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(u)
		cb(u)
	end)
end)

RegisterServerCallback("GetCrew", function(source, cb)
	local identifier = GetLicense(source)

	MySQL.Async.fetchScalar("SELECT crew FROM player_account WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(c)
		cb(c)
	end)
end)

RegisterServerCallback("GetLastPed", function(source, cb)
	local identifier = GetLicense(source)

	MySQL.Async.fetchScalar("SELECT sex FROM player_account WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(ped)
		cb(ped)
	end)
end)

RegisterServerCallback("GetMoney", function(source, cb)
	local identifier = GetLicense(source)

	MySQL.Async.fetchScalar("SELECT money_cash FROM player_account WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(vip)
		cb(vip)
	end)
end)

RegisterServerCallback("getItems", function(source, cb)
	local identifier = GetLicense(source)

	MySQL.Async.fetchScalar("SELECT item FROM items WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(item)
		cb(item)
	end)
end)

RegisterServerCallback("GetGarage", function(source, cb)
	local identifier = GetLicense(source)
	local cars = {}
	MySQL.Async.fetchAll("SELECT vehicle, vehicleuuid, plate, exited FROM vehicle WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(garage)
		for _,v in pairs(garage) do
			table.insert(cars, {
				vehicle = v.vehicle,
				vehicleuuid = v.vehicleuuid,
				state = v.exited
			})
		end
     	cb(cars)
    end)
end)

RegisterServerCallback("GetItems", function(source, cb)
	local identifier = GetLicense(source)
	local items = {}
	MySQL.Async.fetchAll("SELECT item, count FROM items WHERE identifier = @identifier", {
		["@identifier"] = identifier
	}, function(rr)
		for _,v in pairs(rr) do
			table.insert(items, {
				name = v.item,
				count = v.count
			})
		end
     	cb(items)
    end)
end)