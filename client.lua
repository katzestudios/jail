


lib.registerContext({
    id = 'jailmenu',
    title = 'Untersuchungshaft',
    options = {
      {
        title = 'U-Haft',
      },
      {
        title = 'Spieler Einknasten',
        description = 'U-Haft Starten',
        icon = 'check',
        event = 'katze:openinmenu',
        arrow = true,
        args = {}
      },
      {
        title = 'Zeit Hinzufügen',
        description = 'U-Haft Zeit Verlängern',
        icon = 'clock', 
        event = 'SOON',
        arrow = true, 
        disabled = true
      },
      {
        title = 'Spieler Freilassen',
        description = 'Spieler aus der U-Haft Entlassen',
        icon = 'home',
        event = 'SOON',
        arrow = true, 
        disabled = true
      }
    }
})


--[[ SOON
RegisterNetEvent('katze:addtime')
AddEventHandler('katze:addtime', function(args)

  local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
  local player = ESX.PlayerData.identifier
  local playername = ESX.PlayerData.name
  local person = GetPlayerServerId(closestPlayer)

  if closestPlayer == -1 or closestPlayerDistance > 3.0 then
      
    TriggerEvent('katze:closejailmenucl', source)

    lib.notify({
      title = 'Kein Spieler',
      description = 'Niemand ist in der Nähe',
      type = 'error'
  })

  local input = lib.inputDialog('Zeit Hinzufügen', {
  {type = 'slider', label = 'Zeit', description = 'Um wie viel soll Verlängert werden?', placeholder = 'Insgesammte Zeit nicht über 100HE!', icon = 'stopwatch', required = true, min = 0, max = 100},
  {type = 'input', label = 'Grund', description = 'Warum Verlängern?', placeholder = 'Haftbefehl, Vergehen innerhalb U-Haft', icon = 'info', required = true, min = 4, max = 20}

  })

  local time = input[1]
  local reason = input[2]

  TriggerServerEvent('katze:addJailTime', person, time, reason)

end)

]]

RegisterNetEvent('katze:openinmenu')
AddEventHandler('katze:openinmenu', function(args)

    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
    local player = ESX.PlayerData.identifier
    local playername = ESX.PlayerData.name
    local person = GetPlayerServerId(closestPlayer)
  
    if closestPlayer == -1 or closestPlayerDistance > 3.0 then
      
      TriggerEvent('katze:closejailmenucl', source)

      lib.notify({
        title = 'Kein Spieler',
        description = 'Niemand ist in der Nähe',
        type = 'error'
    })

    
    end

    local input = lib.inputDialog('Spieler Einsperren', {
        {type = 'input', label = 'Grund', description = 'Grund der U-Haft', placeholder = 'Strafverfahren..[]', icon = 'info', required = true, min = 4, max = 30},
        {type = 'slider', label = 'Zeit', description = 'Zeit der U-Haft', placeholder = 'Max 100HE', icon = 'stopwatch', required = true, min = 0, max = 100},
        {type = 'input', label = 'Beamte', description = 'Ganzer Name von dem Beamten', placeholder = 'Max Mustermann', icon = 'user', required = true},
        {type = 'input', label = 'Dienstnummer', description = 'Dienstnummer von dem Inhaftierenden Beamten', placeholder = 'HE-01/111', icon = 'lock', required = true},
        {type = 'date', label = 'Tag', description = 'Tag der Inhaftierung', icon = 'calendar', required = true},
        {type = 'time', label = 'Zeit', description = 'Zeit der Inhaftierung', icon = 'clock', required = true},
        {type = 'select', label = 'Zelle', options = { {value = 'cell1', label = 'Zelle 1'}, {value = 'cell2', label = 'Zelle 2'}, {value = 'cell3', label = 'Zelle 3'}, {value = 'cell4', label = 'Zelle 4'}, {value = 'cell5', label = 'Zelle 5'} }}
    })


    local timestamp = math.floor(input[6] / 1000)
    local reason = input[1]
    local time = input[2]
    local officer = input[3]
    local dn = input[4]
    local cell = input[7]

    TriggerServerEvent('katze:logdiscord', 2000, "[" .. officer .. "] Spieler Eingesperrt", "Der Beamte mit der **Dienstnummer: " .. dn .. " **hat die **ID " .. person .. "** für " .. time .. " Minuten in die U-Haft Gesteckt. (" .. cell .. ") Der Grund hierfür: " .. reason .. "")
    TriggerServerEvent('katze:progressJail', person, time, cell)

    if Config.Debug == true then
    print(person)
    print(reason)
    print(time)
    print(officer)
    print(dn)
    print(cell)
    else return
    end

end)

RegisterNetEvent('katze:closejailmenucl')
AddEventHandler('katze:closejailmenucl', function(source)
  
  Citizen.Wait(1)
  lib.closeInputDialog()


end)

RegisterNetEvent('katze:openjailmenu', function(source)

  lib.showContext('jailmenu')

end)


RegisterNetEvent('katze:getintojail')
AddEventHandler('katze:getintojail', function(cell)

  if Config.Debug == true then
    print(cell)
  end

  if cell == 'cell1' then
    teleportPlayerToJail(Config.Cells.cell1)
  elseif cell == 'cell2' then
    teleportPlayerToJail(Config.Cells.cell2)
  elseif cell == 'cell3' then
    teleportPlayerToJail(Config.Cells.cell3)
  elseif cell == 'cell4' then
    teleportPlayerToJail(Config.Cells.cell4)
  elseif cell == 'cell5' then 
    teleportPlayerToJail(Config.Cells.cell5)
  elseif cell == 'free' then
    print('Spieler ist frei, keine Zelle angegeben?')
  else
    print('Error, contact our Support! [ERR0111]')
  end

end)

