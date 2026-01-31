local QBCore = exports['qb-core']:GetCoreObject()

-- Pay for fuel
RegisterNetEvent('fuel:server:PayForFuel', function(amount, isElectric)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local fuelType = isElectric and "electricity" or "fuel"
    
    if Player.PlayerData.money.cash >= amount then
        Player.Functions.RemoveMoney('cash', amount, 'fuel-purchase')
        TriggerClientEvent('QBCore:Notify', src, 'Paid $' .. amount .. ' for ' .. fuelType .. ' with cash', 'success')
    elseif Player.PlayerData.money.bank >= amount then
        Player.Functions.RemoveMoney('bank', amount, 'fuel-purchase')
        TriggerClientEvent('QBCore:Notify', src, 'Paid $' .. amount .. ' for ' .. fuelType .. ' with card', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money', 'error')
    end
end)

-- Jerry can callbacks
QBCore.Functions.CreateCallback('fuel:server:hasJerryCan', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then 
        cb(false, 0)
        return 
    end
    
    local jerrycan = Player.Functions.GetItemByName('jerrycan')
    
    if jerrycan then
        local fuel = jerrycan.info.fuel or 0
        cb(true, fuel)
    else
        cb(false, 0)
    end
end)

RegisterNetEvent('fuel:server:UpdateJerryCan', function(fuelLeft)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local jerrycan = Player.Functions.GetItemByName('jerrycan')
    
    if jerrycan then
        if fuelLeft <= 0 then
            Player.Functions.RemoveItem('jerrycan', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['jerrycan'], 'remove')
        else
            jerrycan.info.fuel = fuelLeft
            Player.Functions.SetInventory(Player.PlayerData.inventory)
        end
    end
end)

-- Buy jerry can
RegisterNetEvent('fuel:server:BuyJerryCan', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    if Player.PlayerData.money.cash >= Config.JerryCanPrice then
        Player.Functions.RemoveMoney('cash', Config.JerryCanPrice, 'jerrycan-purchase')
        Player.Functions.AddItem('jerrycan', 1, false, {fuel = Config.JerryCanCapacity})
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['jerrycan'], 'add')
        TriggerClientEvent('QBCore:Notify', src, 'Purchased jerry can for $' .. Config.JerryCanPrice, 'success')
    elseif Player.PlayerData.money.bank >= Config.JerryCanPrice then
        Player.Functions.RemoveMoney('bank', Config.JerryCanPrice, 'jerrycan-purchase')
        Player.Functions.AddItem('jerrycan', 1, false, {fuel = Config.JerryCanCapacity})
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['jerrycan'], 'add')
        TriggerClientEvent('QBCore:Notify', src, 'Purchased jerry can for $' .. Config.JerryCanPrice, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money', 'error')
    end
end)

-- Refill jerry can
RegisterNetEvent('fuel:server:RefillJerryCan', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local jerrycan = Player.Functions.GetItemByName('jerrycan')
    
    if not jerrycan then
        TriggerClientEvent('QBCore:Notify', src, "You don't have a jerry can", 'error')
        return
    end
    
    if Player.PlayerData.money.cash >= Config.JerryCanRefillPrice then
        Player.Functions.RemoveMoney('cash', Config.JerryCanRefillPrice, 'jerrycan-refill')
        jerrycan.info.fuel = Config.JerryCanCapacity
        Player.Functions.SetInventory(Player.PlayerData.inventory)
        TriggerClientEvent('QBCore:Notify', src, 'Refilled jerry can for $' .. Config.JerryCanRefillPrice, 'success')
    elseif Player.PlayerData.money.bank >= Config.JerryCanRefillPrice then
        Player.Functions.RemoveMoney('bank', Config.JerryCanRefillPrice, 'jerrycan-refill')
        jerrycan.info.fuel = Config.JerryCanCapacity
        Player.Functions.SetInventory(Player.PlayerData.inventory)
        TriggerClientEvent('QBCore:Notify', src, 'Refilled jerry can for $' .. Config.JerryCanRefillPrice, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money', 'error')
    end
end)

-- Add jerry can item to qb-core/shared/items.lua
-- ['jerrycan'] = {['name'] = 'jerrycan', ['label'] = 'Jerry Can', ['weight'] = 5000, ['type'] = 'item', ['image'] = 'jerrycan.png', ['unique'] = true, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A can full of fuel'},
