local inventoryOpen = false
local playerInventory = {}
local ESX = nil

-- Ожидание загрузки ESX
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

-- Регистрация клавиши для открытия инвентаря (по умолчанию I, игрок может изменить)
RegisterKeyMapping('inventory', 'Открыть инвентарь', 'keyboard', 'I')

-- Открытие инвентаря
RegisterCommand('inventory', function()
    if not inventoryOpen and ESX ~= nil then
        ESX.TriggerServerCallback('inventory:loadInventory', function(inventory)
            playerInventory = inventory
            SendNUIMessage({
                action = 'openInventory',
                inventory = playerInventory
            })
            SetNuiFocus(true, true)
            inventoryOpen = true
        end)
    end
end, false)

-- Закрытие инвентаря
RegisterNUICallback('closeInventory', function(data, cb)
    SetNuiFocus(false, false)
    inventoryOpen = false
    cb('ok')
end)

-- Использование предмета
RegisterNUICallback('useItem', function(data, cb)
    local item = data.item
    -- Логика использования предмета
    TriggerServerEvent('inventory:useItem', item)
    cb('ok')
end)

-- Перемещение предмета
RegisterNUICallback('moveItem', function(data, cb)
    local fromSlot = data.fromSlot
    local toSlot = data.toSlot
    -- Логика перемещения
    playerInventory[fromSlot], playerInventory[toSlot] = playerInventory[toSlot], playerInventory[fromSlot]
    TriggerServerEvent('inventory:saveInventory', playerInventory)
    cb('ok')
end)