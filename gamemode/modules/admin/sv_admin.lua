WriteTxtCoords = function(text)
    log = io.open("resources/coords.txt", "a")
    if log then
        log:write(text)
    else
        print("Log file doesnt exist")
    end
    log:close()
end

RegisterServerEvent("SendCoords")
AddEventHandler("SendCoords", function(x,y,z,h)
    coords = vec3(x,y,z)
    WriteTxtCoords(coords .. " + heading : " .. h .. "\n")
end)

RegisterServerEvent("GetUserUUID")
AddEventHandler("GetUserUUID", function(srcID, srcNAME)
    local _src = source
    local identifier = GetLicense(srcID,0)
    MySQL.Async.fetchScalar('SELECT uuid FROM player_account WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        TriggerClientEvent("DisplayNotif", _src, srcNAME .. " uuid: ~HUD_COLOUR_REDLIGHT~" .. result)
    end)
end)

RegisterServerEvent("GetUserRANK")
AddEventHandler("GetUserRANK", function(srcID, srcNAME)
    local _src = source
    local identifier = GetLicense(srcID,0)
    MySQL.Async.fetchAll('SELECT owner, staff, firstspawn FROM player_account WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        sgrp = "<C>~r~User</C>"
        pgrp = "<C>~g~Player</C>"
        for _,v in pairs(result) do
            if v.owner == true then sgrp = "<C>~r~Owner</C>" end
            if v.staff == true then sgrp = "<C>~HUD_COLOUR_REDLIGHT~Staff</C>" end
            if v.firstspawn == false then pgrp = "<C>~g~New player</C>" end
        end
        TriggerClientEvent("DisplayNotif", _src, srcNAME .. " rank:\n" .. sgrp .. "~s~\n" .. pgrp)
    end)
end)

RegisterServerEvent("GetUserMONEY")
AddEventHandler("GetUserMONEY", function(srcID, srcNAME)
    local _src = source
    local identifier = GetLicense(srcID,0)
    MySQL.Async.fetchAll('SELECT * FROM player_account WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        TriggerClientEvent("DisplayNotif", _src, srcNAME .. " money: ~g~$" .. result[1].money_cash)
    end)
end)


RegisterServerEvent("KickPlayer")
AddEventHandler("KickPlayer", function(src, self)
    DropPlayer(src, "You have been kicked by " .. self)
end)