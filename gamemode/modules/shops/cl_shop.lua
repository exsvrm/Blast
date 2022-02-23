-- safe shop
local publicShopList = {
    { ID = 1, name = "VIP", price = "B#15" },
    { ID = 2, name = "drone", price = "$7500" }
}

local publicShopMenu = {
    Base = { Title = "SHOP", HeaderColor = { 25,25,25 } },
    Data = { currentMenu = "shop", TypeBlack = true },
    Events = {
    onSelected = function(self, _, btn, MP, menuData, currentButton, currentSlt, result)
    end
},
Menu = {
    ["shop"] = {
        buttons = publicShopList
    }  
  }
}

-- dark shop
local privateShopList = {
    { ID = 1, name = "drone", price = "$125000", desc = "this drone cannot be jamming." },
    { ID = 2, name = "jammer", price = "$50000" }
}

local privateShopMenu = {
    Base = { Title = "DARK SHOP", HeaderColor = { 25,25,25 } },
    Data = { currentMenu = "dark shop", TypeBlack = true },
    Events = {
    onSelected = function(self, _, btn, MP, menuData, currentButton, currentSlt, result)
    end
},
Menu = {
    ["dark shop"] = {
        buttons = privateShopList
    }  
  }
}


RegisterCommand("l", function()
CreateMenu(publicShopMenu)
end)

RegisterCommand("r", function()
CreateMenu(privateShopMenu)
end)