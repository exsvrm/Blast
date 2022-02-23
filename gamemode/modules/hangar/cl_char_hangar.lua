local m_Handler = {
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -1235.395508, -2985.442627, -41.268616, 0.0, 0.0, -25.0, 50.0, false, 0),
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 156.788483, 5180.429688, -88.673515, 0.0, 0.0, 88.0, 60.0, false, 0),

    disabledControls = {176, 24, 30, 31, 32, 33, 34, 35}
}

BLAST.Hangar.Menu = {
    Base = { Title = "REGISTER" },
    Data = { currentMenu = "register", TypeBlue = true },
    Events = {
        onSelected = function(_, _, Button)
            if Button.var == "nickname" then
                local result = Keyboard("New nickname ?", 15)
                if result ~= nil then
                    BLAST.Hangar.Menu.Menu["register"].buttons[1].RightLabel = result
                end
            end
        end,

        onExited = function()
            BLAST.Hangar:DisableCam()
        end
    },
    Menu = {
        ["register"] = {
            buttons = {
                { name = "nickname", RightLabel = GetPlayerName(PlayerId()), var = "nickname" }
            }
        }
    }
}

function BLAST.Hangar:DisableCam()
    SetCamActive(m_Handler.cam2, false)
    RenderScriptCams(false, true, 2000, false, false)
    DisplayRadar(true)
    FreezeEntityPosition(PlayerPedId(), false)
    CreateThread(function() while true do for _,v in pairs(m_Handler.disabledControls) do EnableControlAction(0, v, true) end Wait(1) end end)
end

RegisterCommand("camHandlerForHangar", function()
    DisplayRadar(false)
    CreateMenu(BLAST.Hangar.Menu)
    SetCamActive(m_Handler.cam2, true)
    RenderScriptCams(true, false, 2000, true, true)
    SetEntityCoords(PlayerPedId(), 153.351303, 5180.429688, -89.673409)
    SetEntityHeading(PlayerPedId(), 274.94396972656)

    FreezeEntityPosition(PlayerPedId(), true)


    CreateThread(function()
    while true do
    for _,v in pairs(m_Handler.disabledControls) do
        DisableControlAction(0, v, true)
    end
    Wait(1)
    end
    end)
end)


CreateThread(function()
    RequestIpl("xs_arena_interior_mod") --205.000, 5180.000, -90.000
	if not IsInteriorReady(GetInteriorAtCoords(205.000, 5180.000, -90.000)) then
		Wait(1)
	end

	EnableInteriorProp(GetInteriorAtCoords(205.000, 5180.000, -90.000), "Set_Int_MOD_SHELL_DEF")

end)