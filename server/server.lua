ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Загрузка инвентаря игрока
ESX.RegisterServerCallback('inventory:loadInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT * FROM user_inventory WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        local inventory = {}
        for i=1, #result do
            inventory[result[i].item] = {
                count = result[i].count,
                slot = result[i].slot
            }
        end
        cb(inventory)
    end)
end)

-- Сохранение инвентаря
RegisterServerEvent('inventory:saveInventory')
AddEventHandler('inventory:saveInventory', function(inventory)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    -- Очистить старый инвентарь
    MySQL.Async.execute('DELETE FROM user_inventory WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })

    -- Вставить новый
    for item, data in pairs(inventory) do
        MySQL.Async.execute('INSERT INTO user_inventory (identifier, item, count, slot) VALUES (@identifier, @item, @count, @slot)', {
            ['@identifier'] = identifier,
            ['@item'] = item,
            ['@count'] = data.count,
            ['@slot'] = data.slot
        })
    end
end)