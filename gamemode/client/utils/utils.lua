function AddLongString(txt)
	if not txt then return end
	local maxLen = 250
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentSubstringPlayerName(sub)
	end
end

function DisplayNotif(message, back)
	if back then ThefeedNextPostBackgroundColor(back) end
	BeginTextCommandThefeedPost("STRING")
	AddLongString(message)
	return EndTextCommandThefeedPostTicker(0, 1)
end

function DisplayHelpNotif(message, beep)
	BeginTextCommandDisplayHelp("STRING")
	AddLongString(message)
	return EndTextCommandDisplayHelp(0, 0, beep, -1)
end

function DisplayNotifIcon(icon, intType, sender, title, text, back)
	if type(icon) == "number" then
		local ped = GetPlayerPed(GetPlayerFromServerId(icon))
		icon = ped and GetPedHeadshot(ped) or GetPedHeadshot(PlayerPedId())
	elseif not HasStreamedTextureDictLoaded(icon) then
		RequestStreamedTextureDict(icon, false)
		while not HasStreamedTextureDictLoaded(icon) do Wait(0) end
	end

	if back then
		ThefeedNextPostBackgroundColor(back)
	end
	BeginTextCommandThefeedPost("STRING")
	AddLongString(text)

	EndTextCommandThefeedPostMessagetext(icon, icon, true, intType, sender, title)
	SetStreamedTextureDictAsNoLongerNeeded(icon)
	return EndTextCommandThefeedPostTicker(0, 1)
end

function Keyboard(name, max)
    AddTextEntry("KEYBOARD", name)
    DisplayOnscreenKeyboard(1, "KEYBOARD", "", "", "", "", "", max)

    while UpdateOnscreenKeyboard() == 0 do
        Wait(5)
    end

	local result = GetOnscreenKeyboardResult()
    
    if result then
        return result
    else
        return nil
    end
end

function SpawnVehicle(model, seat)
local hash = GetHashKey(model)
if hash == nil then return end
RequestModel(hash)
while not HasModelLoaded(hash) do Wait(1) end
local vehicle = CreateVehicle(hash, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, seat)
end

function GetPedHeadshot(ped)
	local handle, startTime = RegisterPedheadshot(ped), GetGameTimer()
	while not IsPedheadshotReady(handle) and startTime + 10000 > GetGameTimer() do
		Citizen.Wait(100)
	end

	return IsPedheadshotReady(handle) and GetPedheadshotTxdString(handle)
end

function SetSkin(skin)
    local modelhashed = GetHashKey(skin)
    RequestModel(modelhashed)
    while not HasModelLoaded(modelhashed) do
        RequestModel(modelhashed)
        Citizen.Wait(0)
    end
    SetPlayerModel(PlayerId(), modelhashed)
end

CreateThread(function()
    while true do
        SetPedCanSwitchWeapon(PlayerPedId(), false)
        SetPlayerCanDoDriveBy(PlayerId(), false)
        Wait(1)
    end
end)

RegisterNetEvent("DisplayNotif")
AddEventHandler("DisplayNotif", function(msg)
DisplayNotif(msg)
end)