ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory

RegisterServerEvent('Esx:id')
AddEventHandler('Esx:id', function()    
    local src = source
    local items = ox_inventory:Search(src, 'count', 'money')
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
    
    if items >= 2000 then 
        ox_inventory:RemoveItem(src, 'money', 2000)
        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
        function(user)
            for i = 1, #user do
                local row = user[i]
                local sex = (row.sex == 'm') and 'M' or 'F'
                local fullName = string.format('%s %s', row.firstname, row.lastname) 
                local metadata = {
                    type = fullName,
                    description = string.format('Name: %s  \nDOB: %s  \nGender: %s  \nHeight: %s',
                    fullName,
                    row.dateofbirth, 
                    sex,  
                    row.height),
                    dateofbirth = row.dateofbirth,   
                    sex = sex,   
                    height = row.height 
                }
                ox_inventory:AddItem(src, 'id', 1, metadata)
            end
        end)
    else
         xPlayer.showNotification("you don't have enough money", "error", 3000)
    end    
end)

RegisterNetEvent('Esx:drive')
AddEventHandler('Esx:drive', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', 'money')
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
        if items >=5000 then 
            ox_inventory:RemoveItem(src, 'money', 5000)

            MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
            function(user)
                for i = 1, #user do
                    local row = user[i]
                    local sex = (row.sex == 'm') and 'M' or 'F'
                    local fullName = string.format('%s %s', row.firstname, row.lastname) 
                    local metadata = {
                        type = fullName,
                        description = string.format('Name: %s  \nDOB: %s  \nGender: %s  \nHeight: %s',
                        fullName,
                        row.dateofbirth, 
                        sex,  
                        row.height),
                        dateofbirth = row.dateofbirth,   
                        sex = sex,   
                        height = row.height 
                    }
                    ox_inventory:AddItem(src, 'drivers', 1, metadata)
                end
            end)
            TriggerEvent('esx_license:addLicense', source, 'drive', function()end)
        else
            xPlayer.showNotification("you don't have enough money", "error", 3000)
        end    
  end)
RegisterNetEvent('Esx:weapon')
AddEventHandler('Esx:weapon', function()
    local src = source
    local items = ox_inventory:Search(src, 'count', 'money')
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
        if items >=5000 then 
            ox_inventory:RemoveItem(src, 'money', 5000)

            MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
            function(user)
                for i = 1, #user do
                    local row = user[i]
                    local sex = (row.sex == 'm') and 'M' or 'F'
                    local fullName = string.format('%s %s', row.firstname, row.lastname) 
                    local metadata = {
                        type = fullName,
                        description = string.format('Name: %s  \nDOB: %s  \nGender: %s  \nHeight: %s',
                        fullName,
                        row.dateofbirth, 
                        sex,  
                        row.height),
                        dateofbirth = row.dateofbirth,   
                        sex = sex,   
                        height = row.height 
                    }
                    ox_inventory:AddItem(src, 'weapon', 1, metadata)
                end
            end)
            TriggerEvent('esx_license:addLicense', source, 'weapon', function()end)
        else
            xPlayer.showNotification("you don't have enough money", "error", 3000)
        end  

end)    

 
ESX.RegisterUsableItem('id',function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
    local playerName = xPlayer.getName()
    local itemCount = ox_inventory:Search(src, 'count', 'id')
    if itemCount == 1 then
        local idItems = ox_inventory:Search(src, 1, 'id') 
        for _, item in pairs(idItems) do
            if item.metadata and item.metadata.type then
                local description = item.metadata.type
                if description == playerName then
                    TriggerClientEvent('Esx:client:showanim',src)
                    Wait(3000)
                    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = identifier
                    }, function(user)
                        if user[1] then
                            local row = user[1]
                            local sex = (row.sex == 'm') and 'M' or 'F'
                            TriggerClientEvent("Esx:client:id", source, source, row.firstname, row.lastname, sex, row.dateofbirth, row.height)
                        else
                            TriggerClientEvent('chat:addMessage', source, {
                                args = { "Your character information was not found." }
                            })
                        end
                    end)
                else
                end
            else
            end
            break  
        end
    end
end)
 

RegisterServerEvent('Esx:server:id')
AddEventHandler('Esx:server:id', function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, targets_have)
    if targets_have then

        local players = ESX.GetPlayers()
        for _, playerId in ipairs(players) do
            if playerId ~= command_owner then
                local targetPed = GetPlayerPed(playerId)
                local ownerPed = GetPlayerPed(command_owner)
                if #(GetEntityCoords(ownerPed) - GetEntityCoords(targetPed)) <= 3.0 then
                    TriggerClientEvent('chat:addMessage', playerId, {
                        template = '<div class="chat-message">' ..
                        '<div class="chat-message-body">' ..
                        '<font color="#8CC9A0"><strong>──────── ID card ────────</strong></font><br>' ..
                        '<strong>Name:</strong> {1} {2}<br>' ..
                        '<strong>Gender:</strong> {3}<br>' ..
                        '<strong>DOB:</strong> {4}<br>' ..
                        '<strong>Height:</strong> {5} cm<br>' ..
                        '<font color="#8CC9A0">────────•••••••••••••────────</font>' ..
                        '</div></div>',
                    args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
                })
                end
            end
        end
    else

        TriggerClientEvent('chat:addMessage', command_owner, {
            template = '<div class="chat-message">' ..
                '<div class="chat-message-body">' ..
                '<font color="#8CC9A0"><strong>──────── ID card ────────</strong></font><br>' ..
                '<strong>Name:</strong> {1} {2}<br>' ..
                '<strong>Gender:</strong> {3}<br>' ..
                '<strong>DOB:</strong> {4}<br>' ..
                '<strong>Height:</strong> {5} cm<br>' ..
                '<font color="#8CC9A0">────────•••••••••••••────────</font>' ..
                '</div></div>',
            args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
        })
    end
end)

ESX.RegisterUsableItem('weapon',function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
    local playerName = xPlayer.getName()
    local itemCount = ox_inventory:Search(src, 'count', 'weapon')
    if itemCount == 1 then
        local idItems = ox_inventory:Search(src, 1, 'weapon') 
        for _, item in pairs(idItems) do
            if item.metadata and item.metadata.type then
                local description = item.metadata.type
                if description == playerName then
                    TriggerClientEvent('Esx:client:showanim',src)
                    Wait(3000)
                    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = identifier
                    }, function(user)
                        if user[1] then
                            local row = user[1]
                            local sex = (row.sex == 'm') and 'M' or 'F'
                            TriggerClientEvent("Esx:client:weapon", source, source, row.firstname, row.lastname, sex, row.dateofbirth, row.height)
                        else
                            TriggerClientEvent('chat:addMessage', source, {
                                args = { "Your character information was not found." }
                            })
                        end
                    end)
                else
                end
            else
            end
            break  
        end
    end
end)
 
 

RegisterServerEvent('Esx:server:weapon')
AddEventHandler('Esx:server:weapon', function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, targets_have)
    if targets_have then

        local players = ESX.GetPlayers()
        for _, playerId in ipairs(players) do
            if playerId ~= command_owner then
                local targetPed = GetPlayerPed(playerId)
                local ownerPed = GetPlayerPed(command_owner)
                if #(GetEntityCoords(ownerPed) - GetEntityCoords(targetPed)) <= 3.0 then
                    TriggerClientEvent('chat:addMessage', playerId, {
                        template = '<div class="chat-message">' ..
                        '<div class="chat-message-body">' ..
                        '<font color="#ff5542"><strong>──────── Weapons license ────────</strong></font><br>' ..
                        '<strong>Name:</strong> {1} {2}<br>' ..
                        '<strong>Gender:</strong> {3}<br>' ..
                        '<strong>DOB:</strong> {4}<br>' ..
                        '<strong>Height:</strong> {5} cm<br>' ..
                        '<font color="#ff5542">────────•••••••••••••••••••••••••••────────</font>' ..
                        '</div></div>',
                    args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
                })
                end
            end
        end
    else

        TriggerClientEvent('chat:addMessage', command_owner, {
            template = '<div class="chat-message">' ..
                '<div class="chat-message-body">' ..
                '<font color="#8CC9A0"><strong>──────── Weapons license ────────</strong></font><br>' ..
                '<strong>Name:</strong> {1} {2}<br>' ..
                '<strong>Gender:</strong> {3}<br>' ..
                '<strong>DOB:</strong> {4}<br>' ..
                '<strong>Height:</strong> {5} cm<br>' ..
                '<font color="#8CC9A0">────────•••••••••••••••••••••••••••────────</font>' ..
                '</div></div>',
            args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
        })
    end
end)

ESX.RegisterUsableItem('drivers',function(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.getIdentifier()
    local playerName = xPlayer.getName()
    local itemCount = ox_inventory:Search(src, 'count', 'drivers')
    if itemCount == 1 then
        local idItems = ox_inventory:Search(src, 1, 'drivers') 
        for _, item in pairs(idItems) do
            if item.metadata and item.metadata.type then
                local description = item.metadata.type
                if description == playerName then
                    TriggerClientEvent('Esx:client:showanim',src)
                    Wait(3000)
                    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, job, height FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = identifier
                    }, function(user)
                        if user[1] then
                            local row = user[1]
                            local sex = (row.sex == 'm') and 'M' or 'F'
                            TriggerClientEvent("Esx:client:drivers", source, source, row.firstname, row.lastname, sex, row.dateofbirth, row.height)
                        else
                            TriggerClientEvent('chat:addMessage', source, {
                                args = { "Your character information was not found." }
                            })
                        end
                    end)
                else
                end
            else
            end
            break  
        end
    end
end)
 
 

RegisterServerEvent('Esx:server:drivers')
AddEventHandler('Esx:server:drivers', function(command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height, targets_have)
    if targets_have then

        local players = ESX.GetPlayers()
        for _, playerId in ipairs(players) do
            if playerId ~= command_owner then
                local targetPed = GetPlayerPed(playerId)
                local ownerPed = GetPlayerPed(command_owner)
                if #(GetEntityCoords(ownerPed) - GetEntityCoords(targetPed)) <= 3.0 then
                    TriggerClientEvent('chat:addMessage', playerId, {
                        template = '<div class="chat-message">' ..
                        '<div class="chat-message-body">' ..
                        '<font color="#f7f54f"><strong>──────── Driver license ────────</strong></font><br>' ..
                        '<strong>Name:</strong> {1} {2}<br>' ..
                        '<strong>Gender:</strong> {3}<br>' ..
                        '<strong>DOB:</strong> {4}<br>' ..
                        '<strong>Height:</strong> {5} cm<br>' ..
                        '<font color="#f7f54f">────────••••••••••••••••••••••────────</font>' ..
                        '</div></div>',
                    args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
                })
                end
            end
        end
    else

        TriggerClientEvent('chat:addMessage', command_owner, {
            template = '<div class="chat-message">' ..
                '<div class="chat-message-body">' ..
                '<font color="#f7f54f"><strong>──────── Driver license ────────</strong></font><br>' ..
                '<strong>Name:</strong> {1} {2}<br>' ..
                '<strong>Gender:</strong> {3}<br>' ..
                '<strong>DOB:</strong> {4}<br>' ..
                '<strong>Height:</strong> {5} cm<br>' ..
                '<font color="#f7f54f">────────••••••••••••••••••••────────</font>' ..
                '</div></div>',
            args = { command_owner, cl_firstname, cl_lastname, sex, dateOfBirth, height }
        })
    end
end)