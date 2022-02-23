local spectate = false

function admin_spectate()
    spectate = not spectate
    --SetFreecamActive(false)
    if spectate and not STAFF_ISDEV_SPECTATE then
    SetFreecamActive(true)
    Citizen.CreateThread(function()
      while spectate do
        ScaleformFreecam()
        if IsControlJustPressed(0, 51) then
            spectate = false
            STAFF_ISDEV_SPECTATE = false
            SetFreecamActive(false)
            local co = GetFreecamPosition()
            SetEntityCoords(PlayerPedId(), co)
        end
        Wait(1)
      end
    end)
    end
end

function ScaleformFreecam()
local buttonsToDraw = {
  {
    ["label"] = "Retour",
  	["button"] = "~INPUT_CONTEXT~"
  },
  {
    ["label"] = "Ouvrir le menu admin",
    ["button"] = "~INPUT_VEH_HEADLIGHT~"
  },
  {
  	["label"] = "Monter",
  	["button"] = "~INPUT_VEH_RADIO_WHEEL~"
  },
  {
    ["label"] = "Vitesse",
  	["button"] = "~INPUT_SPRINT~"
  },
}
Citizen.CreateThread(function() local instructionScaleform = RequestScaleformMovie("instructional_buttons") while not HasScaleformMovieLoaded(instructionScaleform) do Wait(0) end PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL") PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS") PushScaleformMovieFunctionParameterBool(0) PopScaleformMovieFunctionVoid() for i, v in ipairs(buttonsToDraw) do PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT") PushScaleformMovieFunctionParameterInt(i - 1) PushScaleformMovieMethodParameterButtonName(v["button"]) PushScaleformMovieFunctionParameterString(v["label"]) PopScaleformMovieFunctionVoid() end PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS") PushScaleformMovieFunctionParameterInt(-1) PopScaleformMovieFunctionVoid() DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255) end) end