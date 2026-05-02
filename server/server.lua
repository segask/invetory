ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    print("^2[Inventory] ESX успешно загружен на сервере^7")

    -- Загрузка инвентаря игрока
    ESX.RegisterServerCallback('inventory:loadInventory', function(source, cb)
        print("^3[Inventory] Загрузка инвентаря для игрока " .. tostring(source) .. "^7")
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            print("^1[Inventory] Ошибка: игрок не найден^7")
            cb({})
            return
        end

        local identifier = xPlayer.identifier
        print("^3[Inventory] Идентификатор игрока: " .. identifier .. "^7")

        local result = MySQL.query.await('SELECT * FROM user_inventory WHERE identifier = ?', {identifier})
        print("^3[Inventory] Результат запроса: " .. tostring(result) .. "^7")

        local inventory = {}
        if result then
            for i=1, #result do
                inventory[result[i].item] = {
                    count = result[i].count,
                    slot = result[i].slot
                }
                print("^3[Inventory] Предмет: " .. result[i].item .. " x" .. result[i].count .. " в слоте " .. result[i].slot .. "^7")
            end
        end
        print("^3[Inventory] Отправляем инвентарь клиенту^7")
        cb(inventory)
    end)

    -- Сохранение инвентаря
    RegisterServerEvent('inventory:saveInventory')
    AddEventHandler('inventory:saveInventory', function(inventory)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        local identifier = xPlayer.identifier

        -- Очистить старый инвентарь
        MySQL.query.await('DELETE FROM user_inventory WHERE identifier = ?', {identifier})

        -- Вставить новый
        for item, data in pairs(inventory) do
            MySQL.insert.await('INSERT INTO user_inventory (identifier, item, count, slot) VALUES (?, ?, ?, ?)', {
                identifier, item, data.count, data.slot
            })
        end
    end)

    -- Использование предмета (пример)
    RegisterServerEvent('inventory:useItem')
    AddEventHandler('inventory:useItem', function(item)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        -- Здесь можно добавить логику использования предмета
        -- Например, удалить предмет из инвентаря
        print("^3[Inventory] Игрок " .. xPlayer.name .. " использует предмет: " .. item .. "^7")
    end)
end)