
BLAST.Drop.Object = "dt1_tc_dropCrate_pivot"
BLAST.Drop.ObjectHash = 2975184413
BLAST.Drop.LegendaryVehicle = {
    -- 2859440138, -- Khanjali
    -- 788747387, -- Armed buzzard
    -- 2434067162 -- Insurgent
    "khanjali",
    "insurgent",
    "buzzard"
}
BLAST.Drop.Coords = {
    vec3(-485.766998, -953.846313, 23.964046),
    vec3(-476.331573, -893.051880, 23.749104),
    vec3(-510.028961, -740.049194, 32.536041)
}

CreateThread(function()
    -- BLAST.Drop:Add()
    -- BLAST.Drop:CreateBlip()
end)

RegisterCommand("gotodrop", function()
    if BLAST.Group == "dev" then
        SetEntityCoords(PlayerPedId(), BLAST.Drop.ActualDropCoords)
    end
end)

RegisterCommand("genAlLegVehicle", function()
    if dev then
        local random = math.random(#BLAST.Drop.LegendaryVehicle)
        SpawnVehicle(BLAST.Drop.LegendaryVehicle[random], -1)
    end
end)