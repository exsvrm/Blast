lockerMenu = {
    Base = { Title = "Locker" },
    Data = { currentMenu = "locker", TypeBlue = true },
    Events = {
        onSelected = function(_, _, Button)
        end
    },
    Menu = {
        ["locker"] = {
            buttons = {}
        }
    }
}

function BLAST.crewManager:IsNear()
    for _,v in pairs(BLAST.crewManager.Coords) do
        local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(PlayerPedId()))
		if distance <= 0.8 then
			return true
		end
    end
end

function BLAST.crewManager:Blips(type)
    if type == "locker" then
    local blip = AddBlipForCoord(vec3(2805.125732, -3936.971680, 184.410782))
    SetBlipHighDetail(blip, true)
    SetBlipSprite(blip, 568)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 4)
    SetBlipAsShortRange(blip, true)
    SetBlipDisplay(blip, 9)
    EndTextCommandSetBlipName(blip)
    end
end

CreateThread(function()
    RequestIpl("xs_arena_interior_vip") -- 2799.529, -3930.539, 184.000
    BLAST.crewManager:Blips("locker")

    while true do
        local m_Dist = #(vec3(2805.125732, -3936.971680, 184.410782) - GetEntityCoords(PlayerPedId()))
        local t_Dist = #(vec3(2800.325928, -3934.511719, 184.410904) - GetEntityCoords(PlayerPedId()))

        if BLAST.crewManager:IsNear() then
            DisplayHelpNotif("near_crew_manager")
        end

        if m_Dist <= 2 then
            DisplayHelpNotif("near_crew_locker")

            if IsControlJustPressed(0, 51) then

              --  CreateMenu(lockerMenu)
                print("open")
            end
        end

        if t_Dist <= 100 then
            NetworkSetFriendlyFireOption(true)
        end

        Wait(1)
    end
end)

CreateThread(function()
    for i,v in pairs(BLAST.crewManager.Props) do
        local prop = CreateObjectNoOffset(GetHashKey(v.name), v.x, v.y, v.z, false, true, false)
		SetEntityInvincible(prop, true)
	
		--if v.rot then
		--	SetEntityRotation(prop, 0.0, 0.0, v.rot, 2)
		--end

    end
end)

RegisterCommand("additem", function(source, args, rawCommand)
    if dev then
        Server("Additem", args[1])
    end
end)