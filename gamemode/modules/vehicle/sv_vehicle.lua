local function getVehRandomUUID()
    local num = math.random(9,999999999)
	return num
end

RegisterServerEvent("SpawnVehicle")
AddEventHandler("SpawnVehicle", function()
    local _src = source
    local identifier = GetLicense(_src)
    MySQL.Async.fetchAll('SELECT * from vehicle WHERE identifier = @identifier', {
        ["@identifier"] = identifier
    }, function(result)
        TriggerClientEvent("DisplayNotif", _src, result[1].vehicle)
        TriggerClientEvent("SpawnVehicle", _src, result[1].vehicle, -1)
    end)
end)

RegisterServerEvent("UpdateVehicleExitedYes")
AddEventHandler("UpdateVehicleExitedYes", function(vehicle)
    local identifier = GetLicense(source)
    local veh = vehicle
    MySQL.Async.execute('UPDATE vehicle SET exited = @exited WHERE identifier = @identifier AND vehicle = @vehicle', {
		['@exited'] = 1,
        ['@vehicle'] = veh,
		['@identifier'] = identifier
	})
end)

RegisterServerEvent("UpdatePlate")
AddEventHandler("UpdatePlate", function(plate)
    local identifier = GetLicense(source)
    MySQL.Async.execute('UPDATE vehicle SET plate = @plate WHERE identifier = @identifier', {
        ['@plate'] = plate,
		['@identifier'] = identifier
	})
end)

RegisterServerEvent("RegisterVehicle")
AddEventHandler("RegisterVehicle", function()
    local _src = source
    local identifier = GetLicense(_src)
    local vehuuid = getVehRandomUUID()
    --[[MySQL.Async.execute('INSERT INTO vehicle (identifier, vehicle, vehicleuuid) VALUES (@identifier, @vehicle, @vehicleuuid)', {
        ['@identifier'] = identifier,
        ['@vehicle'] = "dominator6",
        ['@vehicleuuid'] = vehuuid
	})--]]
end)