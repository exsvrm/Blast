ServerCallbacks = {}
CurrentRequestId = 0

function Tsc(name, cb, ...)
	ServerCallbacks[CurrentRequestId] = cb

	TriggerServerEvent('Tsc', name, CurrentRequestId, ...)

	if CurrentRequestId < 65535 then
		CurrentRequestId = CurrentRequestId + 1
	else
		CurrentRequestId = 0
	end
end

RegisterNetEvent('serverCallback')
AddEventHandler('serverCallback', function(requestId, ...)
	if ServerCallbacks[requestId] == nil then return end
	ServerCallbacks[requestId](...)
	ServerCallbacks[requestId] = nil
end)