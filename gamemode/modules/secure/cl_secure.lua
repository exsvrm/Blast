BLAST.Secure.Vehicles = {
    1938952078, -- Firetruk
    782665360 -- Rhino
}

RegisterNetEvent("PrintForEveryone")
AddEventHandler("PrintForEveryone", function(text)
    print(text)
end)

RegisterNetEvent("MsgForEveryone")
AddEventHandler("MsgForEveryone", function(type, text)
    if type == "a" then
        DisplayNotif(text)
    end
    if type == "b" and staff or dev then
        print("Staff only")
        DisplayNotif(text)
    end
end)

RegisterNetEvent("ExplosionClient")
AddEventHandler("ExplosionClient", function(cId, cName)
    print("CExplosionEvent [" .. cId .. "] " .. cName  )
end)