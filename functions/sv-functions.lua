-- JailTime


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        local players = GetPlayers()

        for _, playerId in ipairs(players) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            
            if xPlayer then
                local playerIdentifier = xPlayer.getIdentifier()

                MySQL.Async.execute('UPDATE users SET jailtime = GREATEST(jailtime - 1, 0) WHERE identifier = @identifier AND jailtime > 0', {
                    ['@identifier'] = playerIdentifier
                })

                MySQL.Async.fetchScalar('SELECT jailtime FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = playerIdentifier
                }, function(jailtime)
                    if jailtime == 1 then
                        Wait(60000)
                        xPlayer.triggerEvent('katze:startautorelease', playerId)
                    end
                end)
            end
        end
    end
end)


function setJailTime(identifier, JailTime)
    MySQL.Async.execute('UPDATE users SET jailtime = @Time WHERE identifier = @identifier', {
        ['@Time'] = JailTime,
        ['@identifier'] = identifier
    })
end

function getPlayerJailTime(identifier, cb)
    MySQL.Async.fetchScalar('SELECT jailtime FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(jailtime)
        if jailtime then
            cb(jailtime)
        else
            cb(0)
        end
    end)
end

function getPlayerCell(identifier, cb)
    MySQL.Async.fetchScalar('SELECT cell FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(cell)
        if cell then
            cb(cell)
        else
            cb(0)
        end
    end)
end

function notifyPolice(arg1, arg2)
    local xPlayers = ESX.GetPlayers()


    for _, playerId in ipairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer.job.name == Config.PolJob then
            xPlayer.triggerEvent("okokNotify:Alert", arg1, arg2, 5000, 'info', false)


        end
    end
end

function getPlayerDisplayName(playerId)
    return GetPlayerName(playerId)
end



function removeAllWeaponsFromPlayer(xPlayer)
    local weapons = xPlayer.getLoadout()

    for i=1, #weapons, 1 do
        xPlayer.removeWeapon(weapons[i].name)
    end
end

-- Prison Tokens

function addTokens(identifier, amount)
    MySQL.Async.execute('UPDATE users SET jailtokens = jailtokens + @amount WHERE identifier = @player_id', {
        ['@amount'] = amount,
        ['@player_id'] = identifier
    })
end

function removeTokens(identifier, amount)
    MySQL.Async.execute('UPDATE users SET jailtokens = jailtokens - @amount WHERE identifier = @player_id', {
        ['@amount'] = amount,
        ['@player_id'] = identifier
    })
end

function getTokens(identifier, callback)
    MySQL.Async.fetchScalar('SELECT jailtokens FROM users WHERE identifier = @player_id', {
        ['@player_id'] = identifier
    }, function(tokens)
        callback(tokens)
    end)
end


-- ClearDatabase

RegisterNetEvent('katze:cleardatabaseafterjail')
AddEventHandler('katze:cleardatabaseafterjail', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.getIdentifier()

    MySQL.Async.execute('UPDATE users SET cell = @cell WHERE identifier = @identifier', {
        ['@cell'] = 'free',
        ['@identifier'] = identifier
    })

end)

------------------------------------------------------
-- DISCORD LOGS // CLIENT + SERVER LOGS TO WEBHOOK
------------------------------------------------------

local webhook = Config.webhook
function sendCustomDiscordLog(embedColor, title, description)

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'Nord-Hessen RP', 
        embeds = {{
            ["color"] = embedColor, 
            ["author"] = {
                ["name"] = 'Katze.Scripts',
                ["icon_url"] = 'https://cdn.discordapp.com/attachments/1057395544630231040/1242581075197427763/PI.png?ex=666c050e&is=666ab38e&hm=9828be0526d4bf2915633bed85535c8e3021971982c90de428dbe58b156da02f&'
            },
            ["title"] = title,
            ["description"] = description,
            ["footer"] = {
                ["text"] = 'System Logs'.." • "..os.date("%x %X %p"),
                ["icon_url"] = 'https://cdn.discordapp.com/attachments/1057395544630231040/1242581075197427763/PI.png?ex=666c050e&is=666ab38e&hm=9828be0526d4bf2915633bed85535c8e3021971982c90de428dbe58b156da02f&',
            },
        }}, 
        avatar_url = 'https://cdn.discordapp.com/attachments/1057395544630231040/1242581075197427763/PI.png?ex=666c050e&is=666ab38e&hm=9828be0526d4bf2915633bed85535c8e3021971982c90de428dbe58b156da02f&'
    }), { 
        ['Content-Type'] = 'application/json' 
    })
end

RegisterServerEvent('katze:logdiscord')
AddEventHandler('katze:logdiscord', function(embedColor, title, description)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'Nord-Hessen RP', 
        embeds = {{
            ["color"] = '1752220', 
            ["author"] = {
                ["name"] = 'Katze.Scripts',
                ["icon_url"] = 'https://cdn.discordapp.com/attachments/1057395544630231040/1242581075197427763/PI.png?ex=666c050e&is=666ab38e&hm=9828be0526d4bf2915633bed85535c8e3021971982c90de428dbe58b156da02f&'
            },
            ["title"] = title,
            ["description"] = description,
            ["footer"] = {
                ["text"] = 'System Logs'.." • "..os.date("%x %X %p"),
                ["icon_url"] = 'https://cdn.discordapp.com/attachments/1057395544630231040/1242581075197427763/PI.png?ex=666c050e&is=666ab38e&hm=9828be0526d4bf2915633bed85535c8e3021971982c90de428dbe58b156da02f&',
            },
        }}, 
        avatar_url = 'https://cdn.discordapp.com/attachments/1057395544630231040/1242581075197427763/PI.png?ex=666c050e&is=666ab38e&hm=9828be0526d4bf2915633bed85535c8e3021971982c90de428dbe58b156da02f&'
    }), { 
        ['Content-Type'] = 'application/json' 
    })

end)