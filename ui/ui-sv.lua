RegisterNetEvent('katze:sendJailTime')
AddEventHandler('katze:sendJailTime', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local identifier = xPlayer.getIdentifier()
        getPlayerJailTime(identifier, function(jailtime)
            TriggerClientEvent('katze:updateJailTime', _source, jailtime)
        end)
    end
end)