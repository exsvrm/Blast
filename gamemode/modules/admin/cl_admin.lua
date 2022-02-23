local worldgun =  false
dev_in_create = false
STAFF_ISDEV_SPECTATE = false
BLAST.Admin.Insertinfo = {
    { ID = 1, name = nil },
    { ID = 2, name = "player information", slidemax = { "UUID", "Rank", "Crew", "Money", "Identity" } },
    { ID = 3, name = "freeze", checkbox = false },
    { ID = 4, name = "TP", slidemax = { "On me", "On him" } },  
    { ID = 5, name = "warn", RightLabel = "→" },
    { ID = 6, name = "kick", RightLabel = "→" },
    { ID = 7, name = "ban", slidemax = { "1 day","2 days","3 days","4 days","5 days","1 week","2 weeks","1 month","3 month","999 years" } },
    { ID = 8, name = "historical", slidemax = { "Warn", "Kick", "Ban" } }
}

function GetResources()
	local resources = {}
	for i = 1, GetNumResources() do
		resources[i] = GetResourceByFindIndex(i)
	end

	return resources
end

adminMenu = {
    Base = { Title = "Administration", HeaderColor = { 255,0,0 } },
    Data = { currentMenu = "administration", TypeRed = true },

    Events = {
    onSelected = function(self, _, Button, MP, menuData, currentButton, currentSlt, result)

        if Button.var == "PLYList" then
        adminMenu.Menu["player list "].buttons = {{ name = "search a id", var = "SEARCHID", RightLabel = "→" }}
        Tsc("GetActivePlayers", function(playerlist)
        for i,v in pairs(playerlist) do
        table.insert(adminMenu.Menu["player list "].buttons, { name = "("..v.id..") "..v.name.."", PLAYERID = v.id, PLAYERNAME = v.name, var = "PLYOptions" })
        end
        OpenMenu("player list ")
        end)

        elseif Button.var == "SEARCHID" then
        local msg = Keyboard("ID", 6)
        if tonumber(msg) ~= nil then
        adminMenu.Menu["player list "].buttons = {}
        Tsc("GetActivePlayers", function(playerlist)
        for i,v in pairs(playerlist) do
        if tonumber(v.id) == tonumber(msg) then
        table.insert(adminMenu.Menu["player list "].buttons, { name = "("..v.id..") "..v.name.."", PLAYERID = v.id, PLAYERNAME = v.name, var = "PLYOptions" })
        end
        end
        OpenMenu("player list ")
        end) 
        end

        elseif Button.var == "PLYOptions" then
        PLYID = Button.PLAYERID
        PLYNAME = Button.PLAYERNAME
        adminMenu.Menu["player"].buttons[1] = { name = "~r~("..PLYID..") "..PLYNAME }
        OpenMenu("player") 

        elseif Button.ID == 2 and Button.slidenum == 1 then
        Server("GetUserUUID", tonumber(PLYID), PLYNAME)

        elseif Button.ID == 2 and Button.slidenum == 2 then
        Server("GetUserRANK", tonumber(PLYID), PLYNAME)
        
        elseif Button.ID == 2 and Button.slidenum == 4 then
        Server("GetUserMONEY", tonumber(PLYID), PLYNAME)

        elseif Button.var == "gamertags" then
        BLAST.Admin.SetGamerTags()
        
        elseif Button.var == "spectate" then
        --admin_spectate()
        DisplayNotif('Spectate function is not avaible, please say "spectate" in F8 console.')
        CloseMenu()

        elseif Button.var == "cazov" then
        ClearAreaOfVehicles(Player.Pos.x, Player.Pos.y, Player.Pos.z, 50.0, false, false, false, false, false)
        Server("PFE", "ClearAreaOfVehicles")

        elseif Button.var == "rscmng" then
        b = Button.name
        adminMenu.Menu["resource manager "].buttons[1] = { name = "Resource : ~g~" .. Button.name }
        OpenMenu("resource manager ")

        end

    end,
},
Menu = {
    ["administration"] = {
        buttons = {}
    },
    ["player list "] = {
        buttons = {}
    },
    ["player"] = {
        buttons = BLAST.Admin.Insertinfo
    },
    ["world"] = {
        buttons = {
            { name = "gamertags", var = "gamertags", checkbox = false },
            { name = "spectate", var = "spectate", RightLabel = "→" },
            { name = "clear area zone of vehicle", var = "cazov", RightLabel = "→" }
        }
    },
    ["manage"] = {
        buttons = {
            { name = "resource manager", RightLabel = "→" }
        }
    },
    ["resource manager"] = {
        buttons = {}
    },
    ["resource manager "] = {
        buttons = {
            { name = nil },
            -- { name = "Copy the resource", var = "rscCopy" },
            { name = "~r~Stop", var = "rscStop" }
        }
    }
  }
}

Citizen.CreateThread(function()
while true do
Wait(0)

if staff or dev then
if IsControlJustPressed(0, keys["H"]) then

adminMenu.Menu["administration"].buttons = {
    { name = "player list", RightLabel = "→", var = "PLYList" },
    { name = "world", RightLabel = "→" }
}

adminMenu.Menu["resource manager"].buttons = {
    { name = "~g~[Source : " }
}

-- INSERT ELEMENTS
if dev then
-- Manage
table.insert(adminMenu.Menu["administration"].buttons, { name = "manage", RightLabel = "→" })
-- Resource manager
for _,v in pairs(GetResources()) do
table.insert(adminMenu.Menu["resource manager"].buttons, { name = v, RightLabel = "~g~~s~ →", var = "rscmng" })
end
end
-- OPEN
CreateMenu(adminMenu)
end
end
end
end)

RegisterCommand("spectate", function()
  if dev or staff then
    if not STAFF_ISDEV_SPECTATE then
        admin_spectate()
        print(BLAST.Group)
    else
        DisplayNotif("Spectate is already enabled.")
    end
    STAFF_ISDEV_SPECTATE = true
  end
end)

RegisterCommand("dev", function(source, args, rawCommand)
    if dev then

        local disabledControls = {176, 24, 30, 31, 32, 33, 34, 35}

        if args[1] == "coords" then
            local __coords = GetEntityCoords(PlayerPedId())
            Server("SendCoords", __coords.x,__coords.y,__coords.z, GetEntityHeading(PlayerPedId()))
            print("vec3(" .. __coords.x .. "," .. __coords.y .. "," .. __coords.z .. ")")
        end

        if args[1] == "vehicle" then
            if args[2] == "repair" then
                SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId(), false))
                SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId(), 0.0))
            end

            if args[2] == "spawn" then
                veh = Keyboard("VEHICLE", 20)
                if veh ~= nil then
                SpawnVehicle(veh, -1)
                else
                DisplayNotif("Model invalid.")
                end
            end

            if args[2] == "delete" then
                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                DisplayNotif("You must be in a vehicle.")
                elseif IsPedSittingInAnyVehicle(PlayerPedId()) then
                SetEntityAsMissionEntity(GetVehiclePedIsIn(PlayerPedId(), false), 1, 1)
                DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
                DisplayNotif("Vehicle deleted.")
                end
            end
        end
        
        if args[1] == "ped" then
            SetSkin(args[2])
        end

        if args[1] == "heal" then
            SetEntityHealth(PlayerPedId(), 200)
            DisplayNotif("Healed with success.")
        end

        if args[1] == "char_creator_test" then
            DisplayRadar(false)
            SetEntityCoords(PlayerPedId(), -1234.244751, -2982.970703, -42.268616)
            SetEntityHeading(PlayerPedId(), 147.28256225586)
            FreezeEntityPosition(PlayerPedId(), true)
            local char_cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1235.395508, -2985.442627, -41.268616, 0.0, 0.0, -25.0, 50.0, false, 0)
            SetCamActive(char_cam, true)
            RenderScriptCams(true, false, 2000, true, true)
            while true do
            for i,v in pairs(disabledControls) do
                DisableControlAction(0, v, true)
            end
            Citizen.Wait(2)
            end
        end

        if args[1] == "debug" then
            DisplayRadar(true)
            SetTimecycleModifier("")
            FreezeEntityPosition(PlayerPedId(), false)
            CreateThread(function()
            while true do
            for _,v in pairs(disabledControls) do
                EnableControlAction(0, v, true)
            end
            Wait(1)
            end
            end)
        end

        if args[1] == "create" then
            if args[2] == nil then return print("specify true/false.") end

            if args[2] == "true" then
                dev_in_create = true
                print("enabled")
            elseif args[2] == "false" then
                dev_in_create = false
                print("disabled")
            end
        end

        if args[1] == "execute" then
            local e = Keyboard("The code", 512)
            if e ~= nil then
                print(e)
                e()
            end
        end

    end
end)

RegisterCommand("crun", function(source, args, rawCommand)
 if dev then
    local args = args[1]
        local _args
        if not args or args == "" then
        _args = {}
        else
        local e, r = load(args)
        if e then
            _args = e()
        else
            print("(crun) ^1Error : " .. r .. "^7")
        end
    end
  end
end)

local gamerTags = {}
local gamerTagsColor = {}

function BLAST.Admin.SetGamerTags()
    IDActive = not IDActive
    if IDActive then
        CreateThread(function()
            while IDActive do
                local pCoords = GetEntityCoords(PlayerPedId(), false)
				for _,v in pairs(GetActivePlayers()) do
				 local PlayerID = GetPlayerServerId(v)
				  if GetPlayerPed(v) ~= pPed then
                    local otherPed = GetPlayerPed(v)
                    if #(pCoords - GetEntityCoords(otherPed, false)) < 100.0 then
						gamerTags[v] = CreateFakeMpGamerTag(otherPed, " ("..PlayerID..") - "..GetPlayerName(v).."", false, false, "", 0)
						SetMpGamerTagName(gamerTags[v]," ("..PlayerID..") - "..GetPlayerName(v).."")
                        SetMpGamerTagVisibility(gamerTags[v], 2, true) -- HealtArmour

						SetMpGamerTagVisibility(gamerTags[v], 4, NetworkIsPlayerTalking(v)) -- Vocal
						
						SetMpGamerTagColour(gamerTags[v], 0, 225)

						SetMpGamerTagAlpha(gamerTags[v], 4, 255) -- Vocal
                		SetMpGamerTagAlpha(gamerTags[v], 2, 255) -- HealtArmour

                    else
                        RemoveMpGamerTag(gamerTags[v])
                        gamerTags[v] = nil
					end
				  end
                end
                Wait(1)
            end

            for _, v in pairs(gamerTags) do
                RemoveMpGamerTag(v)
                gamerTags[v] = nil
            end
        end)
    end
end