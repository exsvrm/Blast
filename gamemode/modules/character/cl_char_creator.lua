Char = {}
Char.List = {
    { ID = 1, name = "identity", RightLabel = "→" },
    { ID = 2, name = "variations", RightLabel = "→" }
}

local charCreator = {
    Base = { Title = "Character creator" },
    Data = { currentMenu = "character creator", TypeBlue = true },
    Events = {
    onSelected = function(_, _, Button, _, _, _, _, _)
    -- TODO: selected
    end,

    onSlide = function(_, Button, _, _)
    -- TODO: slide
        if Button.ID == 21 then
            SetPedComponentVariation(PlayerPedId(), Button.varType, Button.slidenum)
            Button.advSlider = {0, GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, Button.slidenum) -1, 0, 0}
        end
    end,

    onAdvSlide = function(self, _, Button, currentBtn, currentButtons)
    -- TODO: advSlide
        if Button.ID == 21 then
            SetPedComponentVariation(PlayerPedId(), 11, GetPedDrawableVariation(PlayerPedId(), 11), Button.advSlider[3])
        end
    end,
},
Menu = {
    ["character creator"] = {
        buttons = Char.List
    },
    ["variations"] = {
        extra = true,
        buttons = {
            { ID = 21, varType = 11, name = "variation", slidemax = 382, advSlider = {0, GetNumberOfPedTextureVariations(PlayerPedId(), 11), 0} }
        }
    }
  }
}

RegisterCommand("TestCC", function(...)
    if dev then
        CreateMenu(charCreator)
    end
end)