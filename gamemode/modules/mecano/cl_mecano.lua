BLAST.Mecano.BMCoords = vec3(-442.113190, -943.806885, 29.392809)
BLAST.Mecano.Coords = vec3(-339.013062, -136.594620, 39.009659)
BLAST.Mecano.Heading = 287.75930786133

BLAST.Mecano.Cam = {}
BLAST.Mecano.Cam.Coords = vec3(-332.797699, -134.371048, 39.009632)

mecanoMenu = {
    Base = { Title = "Mecano", HeaderColor = { 12,12,12 } },
    Data = { currentMenu = "mecano", TypeBlack = true, RemoveWorld = true },
    Events = {
        onSelected = function(_, _, Button)
            if Button.Name == "lets go" then
                print("raw e")
            end
        end
    },
    Menu = {
        ["mecano"] = {
            buttons = {
                { name = "lets go" }
            }
        }
    }
}

function BLAST.Mecano:Open()
    --print("lo")
    DisplayRadar(false)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", self.Cam.Coords, 0.0, 0.0, 112.5, 50.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 2000, true, true)

    CreateMenu(mecanoMenu)
end

CreateThread(function()
    while true do
        local dist = #(BLAST.Mecano.BMCoords - GetEntityCoords(PlayerPedId()))

        if dist <= 1 then
            DisplayHelpNotif("~HUD_COLOUR_NET_PLAYER27~Appuyez sur ~INPUT_CONTEXT~ pour ~b~accéder au mécano~HUD_COLOUR_NET_PLAYER27~.")

            if IsControlJustPressed(0, 51) then
                
                BLAST.Mecano:Open()
            end
        end

        Wait(1)
    end
end)

RegisterCommand("mecanoTestCamHandler", function()
    if dev then
        BLAST.Mecano:Open()
    end
end)