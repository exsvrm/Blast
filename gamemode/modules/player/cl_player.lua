Player.ID = GetPlayerServerId(PlayerId())
Player.Pos = GetEntityCoords(PlayerPedId())
Player.Name = GetPlayerName(PlayerId())
Player.Health = GetEntityHealth(PlayerPedId())
Player.Armor = 0
Player.Invincible = false
Player.FallingBoolean = false
Items = {}

function Player:Set(a)
    if a == "_inv" then
        SetEntityOnlyDamagedByPlayer(PlayerPedId(), self.Invincible)
    end
end


function Player.InitItems()
    Tsc("GetItems", function(items)
        for i = 1, #items, 1 do
            TriggerEvent("PREFIX_PLACEHOLDER:addItem", {
                name = items[i].name,
                count = items[i].count
            })
        end
    end)
end

function Player.GetItems()
    return BLAST.Player.Items
end

-- Todo: invincible on falling
CreateThread(function()
    Player.InitItems()

    while true do
        Wait(0)

        if IsPedFalling(PlayerPedId()) then
            Player.Invincible = true
            -- SetEntityOnlyDamagedByPlayer(PlayerPedId(), true)
            Player:Set("_inv")

            if not Player.FallingBoolean then
                Player.FallingBoolean = false
                Server("PFE", "NetworkEntityDamage")
                Player.FallingBoolean = true
            end
        end
        if not IsPedFalling(PlayerPedId()) then
            Player.Invincible = false
            -- SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
            Player:Set("_inv")
        end

    end
end)

RegisterNetEvent("PREFIX_PLACEHOLDER:addItem")
AddEventHandler("PREFIX_PLACEHOLDER:addItem", function(Item)
    table.insert(BLAST.Player.Items, Item)

    print(json.encode(Item))
end)