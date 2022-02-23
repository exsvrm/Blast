BLAST.Combat.inCombat = false

BLAST.Combat.Data = {
    -- Todo: positions
    { x = 388.7849, y = -355.974, z = 48.02319 },
    { x = -3015.004, y = 409.4063, z = 19.28228 },
    { x = -2323.817139, y = 3101.689453, z = 32.826759 },
    { x = -1983.784424, y =-327.803711, z = 47.882122 },
    { x = -1724.410522, y = -190.865280, z = 60.084797 },
    { x = 438.258942, y = -983.449158, z = 43.691559 },
    { x = -36.416275, y = -1105.939941, z = 26.421740 },
    { x = -502.772491, y = -2819.888428, z = 6.000293 },
    { x = 76.490860, y = 3705.062012, z = 41.826733 },
    { x = -1132.877319, y = 4922.653809, z = 219.795151 },
    { x = -576.204407, y = 5326.892578, z = 70.214363 },
    { x = 414.506073, y = 6482.908203, z = 28.808048 },
    { x = 771.588257, y = -233.878372, z = 65.589348 }
    -- Todo: others
    --inCombat = false
}

function BLAST.Combat:Blip(Data)
    for _,v in pairs(BLAST.Combat.Data) do
    local blip = AddBlipForRadius(v.x, v.y, v.z, 100.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 6)
    SetBlipAlpha(blip, 128)
    blip = AddBlipForCoord(v.x, v.y, v.z)
    SetBlipHighDetail(blip, true)
    SetBlipSprite(blip, invisible)
    SetBlipScale(blip, 0.0)
    SetBlipColour(blip, 6)
    SetBlipAsShortRange(blip, true)
    SetBlipDisplay(blip, 3)
  
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zone de combat")
    EndTextCommandSetBlipName(blip)
    end
end

local function SetNewCombatZone()
    local random = math.random(#BLAST.Combat.Data)
    BLAST.Combat.actualcombat = BLAST.Combat.Data[random]
    BLAST.Combat.x, BLAST.Combat.y, BLAST.Combat.z = table.unpack(BLAST.Combat.actualcombat)
    BLAST.Combat:Blip({
        coords = BLAST.Combat.actualcombat,
        c = 6,
        a = 128,
        s = invisible,
        s2 = 0.0
    })
    -- TODO
    local hashCombat = GetStreetNameAtCoord(BLAST.Combat.x, BLAST.Combat.y, BLAST.Combat.z)
    Server("Updateredzone", GetStreetNameFromHashKey(hashCombat))
end

function BLAST.Combat:NearCombat()
    for _,v in pairs(BLAST.Combat.Data) do
		local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, GetEntityCoords(PlayerPedId()))
		if distance <= 100 then
			return true
		end
	end
end

CreateThread(function()
    BLAST.Combat:Blip()

    while true do
        if BLAST.Combat:NearCombat() and not BLAST.Combat.inCombat then
            DisplayNotif("Vous entrez en zone combat.")
            BLAST.Combat.inCombat = true
        end
        if not BLAST.Combat:NearCombat() and BLAST.Combat.inCombat then
            DisplayNotif("Vous n'êtes plus dans la zone de combat.")
            BLAST.Combat.inCombat = false
        end
    Wait(1)
    end
end)

RegisterCommand("gotocombat", function()
if staff or dev then
    local random = math.random(#BLAST.Combat.Data)
    SetEntityCoords(PlayerPedId(), BLAST.Combat.Data[random])
end
end)