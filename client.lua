local QBCore = exports['qb-core']:GetCoreObject()
local isRefueling = false
local isNearStation = false
local currentStation = nil
local fuelSynced = false
local showHUD = true
local hasJerryCan = false
local jerryCanFuel = 0

-- Initialize fuel on vehicle spawn
CreateThread(function()
    DecorRegister(Config.FuelDecor, 1)
    
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
                if not fuelSynced then
                    if not DecorExistOn(vehicle, Config.FuelDecor) then
                        SetFuel(vehicle, math.random(25, 75))
                    end
                    fuelSynced = true
                end
            end
        else
            fuelSynced = false
        end
    end
end)

-- Fuel consumption thread
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
                local fuel = GetFuel(vehicle)
                local vehicleClass = GetVehicleClass(vehicle)
                local model = GetEntityModel(vehicle)
                
                -- Skip fuel consumption for bicycles and electric vehicles
                if Config.ClassConsumption[vehicleClass] > 0 and not IsElectricVehicle(model) then
                    local speed = GetEntitySpeed(vehicle)
                    local rpm = GetVehicleCurrentRpm(vehicle)
                    
                    if speed > 0 then
                        local consumption = Config.FuelConsumption * Config.ClassConsumption[vehicleClass] * (rpm * 0.5 + 0.5) / 100
                        
                        local newFuel = fuel - consumption
                        if newFuel < 0 then newFuel = 0 end
                        
                        SetFuel(vehicle, newFuel)
                        
                        -- Engine dies when out of fuel
                        if newFuel <= 0 then
                            SetVehicleEngineOn(vehicle, false, true, true)
                        end
                    end
                end
            end
        end
    end
end)

-- Station detection thread
CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local inStation = false
        
        for k, station in pairs(Config.GasStations) do
            local dist = #(coords - station.coords)
            if dist < 15.0 then
                inStation = true
                currentStation = station
                break
            end
        end
        
        -- Check charging stations for electric vehicles
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local model = GetEntityModel(vehicle)
            
            if IsElectricVehicle(model) then
                for k, station in pairs(Config.ChargingStations) do
                    local dist = #(coords - station.coords)
                    if dist < 15.0 then
                        inStation = true
                        currentStation = station
                        break
                    end
                end
            end
        end
        
        isNearStation = inStation
        
        if not inStation then
            currentStation = nil
        end
    end
end)

-- Main refueling thread
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        
        if isNearStation and not isRefueling then
            sleep = 0
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
                local fuel = GetFuel(vehicle)
                local model = GetEntityModel(vehicle)
                local isElectric = IsElectricVehicle(model)
                
                if fuel < 95 then
                    DrawText3D(GetEntityCoords(ped), isElectric and "[E] Charge Vehicle" or "[E] Refuel Vehicle")
                    
                    if IsControlJustPressed(0, 38) then -- E key
                        StartRefuel(vehicle, isElectric)
                    end
                end
            elseif not IsPedInAnyVehicle(ped, false) then
                -- Jerrycan refuel
                local coords = GetEntityCoords(ped)
                local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 70)
                
                if vehicle ~= 0 and DoesEntityExist(vehicle) then
                    local fuel = GetFuel(vehicle)
                    
                    if fuel < 95 then
                        DrawText3D(GetEntityCoords(vehicle), "[G] Refuel with Jerry Can")
                        
                        if IsControlJustPressed(0, 47) then -- G key
                            QBCore.Functions.TriggerCallback('fuel:server:hasJerryCan', function(has, amount)
                                if has then
                                    hasJerryCan = true
                                    jerryCanFuel = amount
                                    StartJerryCanRefuel(vehicle)
                                else
                                    QBCore.Functions.Notify("You don't have a jerry can", "error")
                                end
                            end)
                        end
                    end
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- HUD Display
CreateThread(function()
    while true do
        Wait(100)
        
        if Config.ShowFuelHUD and showHUD then
            local ped = PlayerPedId()
            
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                
                if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
                    local fuel = GetFuel(vehicle)
                    local model = GetEntityModel(vehicle)
                    local isElectric = IsElectricVehicle(model)
                    
                    -- Get speed (convert from m/s to MPH)
                    local speed = GetEntitySpeed(vehicle) * 2.236936
                    
                    SendNUIMessage({
                        action = "updateHUD",
                        show = true,
                        fuel = math.floor(fuel),
                        speed = math.floor(speed),
                        isElectric = isElectric,
                        hudSize = Config.HUDSize or "small"
                    })
                else
                    SendNUIMessage({
                        action = "updateHUD",
                        show = false
                    })
                end
            else
                SendNUIMessage({
                    action = "updateHUD",
                    show = false
                })
            end
        end
    end
end)

-- Functions
function StartRefuel(vehicle, isElectric)
    isRefueling = true
    local fuel = GetFuel(vehicle)
    local maxFuel = 100
    local price = isElectric and Config.ElectricChargePrice or Config.FuelPrice
    local speed = isElectric and Config.ChargeSpeed or Config.RefuelSpeed
    
    -- Turn off engine
    SetVehicleEngineOn(vehicle, false, true, true)
    
    QBCore.Functions.Notify(isElectric and "Charging started..." or "Refueling started...", "success")
    
    SendNUIMessage({
        action = "showRefuel",
        show = true,
        fuel = math.floor(fuel),
        isElectric = isElectric
    })
    
    CreateThread(function()
        while isRefueling do
            Wait(100)
            
            fuel = GetFuel(vehicle)
            
            if fuel >= maxFuel then
                StopRefuel(vehicle, fuel, price, isElectric)
                break
            end
            
            -- Check if player cancelled
            if IsControlJustPressed(0, 194) then -- BACKSPACE
                StopRefuel(vehicle, fuel, price, isElectric)
                break
            end
            
            -- Increase fuel
            local newFuel = fuel + (speed / 10)
            if newFuel > maxFuel then newFuel = maxFuel end
            
            SetFuel(vehicle, newFuel)
            
            SendNUIMessage({
                action = "updateRefuel",
                fuel = math.floor(newFuel)
            })
        end
    end)
end

function StopRefuel(vehicle, finalFuel, pricePerUnit, isElectric)
    isRefueling = false
    
    SendNUIMessage({
        action = "showRefuel",
        show = false
    })
    
    -- Calculate cost
    local startFuel = GetFuel(vehicle)
    local fuelAdded = finalFuel - startFuel
    local totalCost = math.floor(fuelAdded * pricePerUnit)
    
    if fuelAdded > 0 then
        TriggerServerEvent('fuel:server:PayForFuel', totalCost, isElectric)
    else
        QBCore.Functions.Notify(isElectric and "Charging cancelled" or "Refueling cancelled", "error")
    end
end

function StartJerryCanRefuel(vehicle)
    if jerryCanFuel <= 0 then
        QBCore.Functions.Notify("Jerry can is empty", "error")
        return
    end
    
    isRefueling = true
    local fuel = GetFuel(vehicle)
    local ped = PlayerPedId()
    
    -- Play animation
    RequestAnimDict("weapon@w_sp_jerrycan")
    while not HasAnimDictLoaded("weapon@w_sp_jerrycan") do
        Wait(100)
    end
    
    TaskPlayAnim(ped, "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, false, false, false)
    
    QBCore.Functions.Notify("Refueling from jerry can...", "success")
    
    CreateThread(function()
        while isRefueling and jerryCanFuel > 0 do
            Wait(100)
            
            fuel = GetFuel(vehicle)
            
            if fuel >= 100 or jerryCanFuel <= 0 then
                isRefueling = false
                ClearPedTasks(ped)
                TriggerServerEvent('fuel:server:UpdateJerryCan', jerryCanFuel)
                QBCore.Functions.Notify("Refueling complete", "success")
                break
            end
            
            if IsControlJustPressed(0, 194) then -- BACKSPACE
                isRefueling = false
                ClearPedTasks(ped)
                TriggerServerEvent('fuel:server:UpdateJerryCan', jerryCanFuel)
                QBCore.Functions.Notify("Refueling cancelled", "error")
                break
            end
            
            local newFuel = fuel + 0.15
            jerryCanFuel = jerryCanFuel - 0.15
            
            if newFuel > 100 then newFuel = 100 end
            if jerryCanFuel < 0 then jerryCanFuel = 0 end
            
            SetFuel(vehicle, newFuel)
        end
    end)
end

function SetFuel(vehicle, fuel)
    if DoesEntityExist(vehicle) then
        DecorSetFloat(vehicle, Config.FuelDecor, fuel + 0.0)
    end
end

function GetFuel(vehicle)
    if DoesEntityExist(vehicle) then
        return DecorGetFloat(vehicle, Config.FuelDecor)
    end
    return 0
end

function IsElectricVehicle(model)
    local modelName = string.lower(GetDisplayNameFromVehicleModel(model))
    
    for _, electric in pairs(Config.ElectricVehicles) do
        if modelName == string.lower(electric) then
            return true
        end
    end
    
    return false
end

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - coords)
    
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Create blips
CreateThread(function()
    if Config.ShowBlips then
        for k, station in pairs(Config.GasStations) do
            local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
            SetBlipSprite(blip, Config.BlipSprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.BlipScale)
            SetBlipColour(blip, Config.BlipColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(station.name)
            EndTextCommandSetBlipName(blip)
        end
        
        for k, station in pairs(Config.ChargingStations) do
            local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
            SetBlipSprite(blip, 620)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.BlipScale)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(station.name)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Commands
RegisterCommand('togglefuelhud', function(source, args, rawCommand)
    showHUD = not showHUD
    QBCore.Functions.Notify("Fuel HUD " .. (showHUD and "enabled" or "disabled"), "success")
end, false)

-- NUI Callbacks
RegisterNUICallback('closeRefuel', function(data, cb)
    if isRefueling then
        isRefueling = false
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        if vehicle ~= 0 then
            local fuel = GetFuel(vehicle)
            StopRefuel(vehicle, fuel, Config.FuelPrice, false)
        end
    end
    cb('ok')
end)

-- Export functions
exports('GetFuel', GetFuel)
exports('SetFuel', SetFuel)
