AddEventHandler("playerSpawned", function()
    Tsc("GetMoney", function(Money)
        print(Money)

        -- SetMoney(money)
    end)

    Tsc("GetLastPed", function(Ped)
        -- SetSkin(ped)
        print(json.encode({ped = Ped}))
    end)
end)

RegisterCommand("testFade", function()
	DoScreenFadeOut(500)

	while not IsScreenFadedOut() do
		Citizen.Wait(50)
	end

    DoScreenFadeIn(1500)
end)