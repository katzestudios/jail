local jailTime = 0

RegisterNetEvent('katze:updateJailTime')
AddEventHandler('katze:updateJailTime', function(time)
    jailTime = time
    if jailTime > 0 then
        SendNUIMessage({
            type = 'updateJailTime',
            jailTime = jailTime
        })
    else
        SendNUIMessage({
            type = 'updateJailTime',
            jailTime = 0
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        TriggerServerEvent('katze:sendJailTime')
        Citizen.Wait(60000)
    end
end)