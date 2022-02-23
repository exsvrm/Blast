-- @ set on bucket
function SetonBucket(b)
    return SetPlayerRoutingBucket(source, b)
end


-- @ get ply license
function GetLicense(id)
    for k, v in pairs(GetPlayerIdentifiers(id)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
    return "err"
end


-- @ get source license
function GetLicenseOfSource()
    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
    return "err"
end

-- @ get group
function GetGrp()
    local identifier = GetLicenseOfSource()
    mygrp = "user"

    MySQL.Async.fetchAll('SELECT owner, staff FROM player_account WHERE identifier = @identifier', {
        ["@identifier"] = identifier
    }, function(result)
        for _,v in pairs(result) do
        if v.owner == true then mygrp = "owner" end
        if v.staff == true then mygrp = "staff" end
        end
    end)
end

function InitRank()
    MySQL.Async.fetchAll('SELECT owner, staff FROM player_account', {
        ["@identifier"] = identifier
    }, function(result)
        for _,v in pairs(result) do
        if v.owner == true then mygrp = "owner" end
        if v.staff == true then mygrp = "staff" end
        end
    end)
end

-- @ send notif to all staff connect
function DisplayNotifStaff(message)
    local Players = GetPlayers()
    GetGrp() -- Call the group
	for i=1, #Players, 1 do
		if mygrp == "staff" or "owner" then
			TriggerClientEvent("DisplayNotif", Players[i], message)
		end
	end
end

-- @ get random uuid
function GetRandomUuid()
    local nums = math.random(0,9999)
    local randomString = math.random(#string)
    local randomString2 = math.random(#string)
    local randomString3 = math.random(#string)
    local randomString4 = math.random(#string)
    local num = string[randomString]..""..string[randomString2]..""..string[randomString3]..""..nums..""
	return num
end