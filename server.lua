RegisterNetEvent('katze:timestamp')
AddEventHandler('katze:timestamp', function(timestamp)

    local date = os.date('%Y-%m-%d %H:%M:%S', timestamp)
    
    TriggerClientEvent('katze:senddatetoclient', date)

end)

RegisterNetEvent('katze:progressJail')
AddEventHandler('katze:progressJail', function(person, time, cell)

    local xPlayer = ESX.GetPlayerFromId(person)
    local personidentifier = xPlayer.getIdentifier()
    
    if Config.RemoveWeapons == true then

        removeAllWeaponsFromPlayer(xPlayer)
    end

    if Config.Debug == true then
        print(person)
        print(time)
        print(cell)
    else return 
    end

    MySQL.Async.execute('UPDATE users SET jailtime = @time WHERE identifier = @player_id', {
        ['@time'] = time,
       ['@player_id'] = personidentifier
    })

    MySQL.Async.execute('UPDATE users SET cell = @cell WHERE identifier = @player_id', {
        ['@cell'] = cell,
        ['@player_id'] = personidentifier
    })

    xPlayer.triggerEvent("katze:getintojail", cell)
 end)


-- Player leaved while Jailed


RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
    Citizen.Wait(2000)
    local identifier = xPlayer.getIdentifier()
    local person = xPlayer.getName()
    local username = getPlayerDisplayName(player)


    MySQL.Async.fetchScalar('SELECT cell FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(cell)



    MySQL.Async.fetchScalar('SELECT jailtime, cell FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result > 0 then
            xPlayer.triggerEvent('katze:getintojail', cell)
            TriggerEvent('katze:logdiscord', 11027200, "Person Wiedergekehrt", "Der Insasse " .. person .. " aus Zelle " .. cell .. " ist wieder wach. Username: " .. username .. "" )
            notifyPolice("Insasse Aufgewacht", "Der Insasse " .. person .. " aus Zelle " .. cell .. " ist wieder wach.", 3500, "info")
            local data = {
                title = 'Teleportiert', 
                description = 'Du wurdest zurück in die Zelle Teleportiert.',
                position = 'top'
            }

            xPlayer.triggerEvent('ox_lib:notify', player, data)
        
        end
    end)
    end)

    TriggerEvent('katze:sendJailTime')

    if Config.Debug == true then
        --print(identifier)

    end
end)


RegisterNetEvent('esx:playerDropped', function(playerId, reason)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local person = xPlayer.getName()
    local identifier = xPlayer.getIdentifier()
    local username = getPlayerDisplayName(playerId)

    MySQL.Async.fetchScalar('SELECT cell FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(cell)



    MySQL.Async.fetchScalar('SELECT jailtime FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result > 0 then
            xPlayer.triggerEvent('katze:getintojail', cell)
            TriggerEvent('katze:logdiscord', 11027200, "Person Ein-Geschlafen", "Der Insasse " .. person .. " aus Zelle " .. cell .. " ist eingeschlafen. Username: " .. username .. "" )
            notifyPolice("Insasse Eingeschlafen", "Der Insasse " .. person .. " aus Zelle " .. cell .. " ist eingeschlafen.")
        
        end
    end)
    end)
end)

RegisterNetEvent('katze:addJailTime')
AddEventHandler('katze:addJailTime', function(person, time, reason)
    local xPlayer = GetPlayerFromId(person)
    local identifier = xPlayer.getIdentifier()

    local jailtime = getPlayerJailTime(identifier)
    

    if xPlayer then
        MySQL.Async.execute('UPDATE users SET jailtime = jailtime + @amount WHERE identifier = @player_id', {
            ['@amount'] = time,
            ['@player_id'] = identifier
        })
    end
end)

RegisterCommand(Config.Command, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local job = xPlayer.getJob()

        if job and job.name == Config.PolJob then
            TriggerClientEvent('katze:openjailmenu', source)
        else
            TriggerClientEvent('okokNotify:Alert', source, 'Fehler', 'Dir fehlen die Berechtigungen, diesen Command zu nutzen.', 5000, 'warning', false)
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, 'Fehler', 'Spieler konnte nicht gefunden werden.', 5000, 'warning', false)
    end
end, false)