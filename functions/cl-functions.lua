function teleportPlayerToJail(coords)
    DoScreenFadeOut(100)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    SetEntityHeading(playerPed, coords.heading or GetEntityHeading(playerPed))

    Citizen.Wait(500)

    DoScreenFadeIn(100)
end

RegisterNetEvent('katze:startautorelease')
AddEventHandler('katze:startautorelease', function(playerId)

    DoScreenFadeOut(100)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, Config.Releasepoint.x, Config.Releasepoint.y, Config.Releasepoint.z, false, false, false, true)
    SetEntityHeading(playerPed, Config.Releasepoint.heading or GetEntityHeading(playerPed))

    Citizen.Wait(500)

    DoScreenFadeIn(100)

    TriggerServerEvent('katze:cleardatabaseafterjail', playerId)
end)