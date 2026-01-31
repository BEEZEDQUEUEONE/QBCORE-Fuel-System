Config = {}

-- General Settings
Config.FuelDecor = "_FUEL_LEVEL"
Config.FuelPrice = 3 -- Price per liter
Config.RefuelSpeed = 1.5 -- Liters per second
Config.FuelConsumption = 3.0 -- Base fuel consumption rate (lower = less consumption)

-- Jerrycan Settings
Config.JerryCanCapacity = 20 -- Liters
Config.JerryCanPrice = 150 -- Price to buy a jerrycan
Config.JerryCanRefillPrice = 50 -- Price to refill jerrycan

-- Electric Vehicle Settings
Config.ElectricChargePrice = 2 -- Price per percent
Config.ChargeSpeed = 0.5 -- Percent per second

-- UI Settings
Config.ShowFuelHUD = true -- Show fuel gauge on screen
Config.HUDPosition = "bottom-right" -- Options: "bottom-right", "bottom-left", "top-right", "top-left"

-- Blip Settings
Config.ShowBlips = true
Config.BlipSprite = 361
Config.BlipColor = 4
Config.BlipScale = 0.8

-- Gas Station Locations
Config.GasStations = {
    -- Los Santos
    {coords = vector3(49.4187, 2778.793, 58.043), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(263.894, 2606.463, 44.983), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(1039.958, 2671.134, 39.550), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(1207.260, 2660.175, 37.899), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(2539.685, 2594.192, 37.944), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(2679.858, 3263.946, 55.240), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(2005.055, 3773.887, 32.403), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(1687.156, 4929.392, 42.078), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(1701.314, 6416.028, 32.763), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(179.857, 6602.839, 31.868), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(-94.4619, 6419.594, 31.489), heading = 0.0, name = "Xero Gas Station"},
    {coords = vector3(-2554.996, 2334.40, 33.078), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(-1800.375, 803.661, 138.651), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(-1437.622, -276.747, 46.207), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(-2096.243, -320.286, 13.168), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(-724.619, -935.1631, 19.213), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(-526.019, -1211.003, 18.184), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(-70.2148, -1761.792, 29.534), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(265.648, -1261.309, 29.292), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(819.653, -1028.846, 26.403), heading = 0.0, name = "LTD Gas Station"},
    {coords = vector3(1208.951, -1402.567, 35.224), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(1181.381, -330.847, 69.316), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(620.843, 269.100, 103.089), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(2581.321, 362.039, 108.468), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(176.631, -1562.025, 29.263), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(176.631, -1562.025, 29.263), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(-319.292, -1471.715, 30.549), heading = 0.0, name = "Ron Gas Station"},
    {coords = vector3(1784.324, 3330.55, 41.253), heading = 0.0, name = "Ron Gas Station"}
}

-- Electric Charging Stations
Config.ChargingStations = {
    {coords = vector3(-2096.243, -320.286, 13.168), heading = 0.0, name = "Electric Charging"},
    {coords = vector3(265.648, -1261.309, 29.292), heading = 0.0, name = "Electric Charging"},
    {coords = vector3(1208.951, -1402.567, 35.224), heading = 0.0, name = "Electric Charging"}
}

-- Electric Vehicles (Add model names here)
Config.ElectricVehicles = {
    "voltic",
    "surge",
    "raiden",
    "cyclone",
    "tezeract",
    "neon",
    "iwagen", -- If you have electric vehicle mods
}

-- Vehicle Classes Fuel Consumption Multipliers
Config.ClassConsumption = {
    [0] = 1.0,  -- Compacts
    [1] = 1.0,  -- Sedans
    [2] = 1.0,  -- SUVs
    [3] = 1.0,  -- Coupes
    [4] = 1.0,  -- Muscle
    [5] = 1.0,  -- Sports Classics
    [6] = 1.0,  -- Sports
    [7] = 1.0,  -- Super
    [8] = 0.5,  -- Motorcycles
    [9] = 1.2,  -- Off-road
    [10] = 1.5, -- Industrial
    [11] = 1.2, -- Utility
    [12] = 1.0, -- Vans
    [13] = 0.0, -- Cycles (no fuel)
    [14] = 0.5, -- Boats
    [15] = 1.8, -- Helicopters
    [16] = 2.0, -- Planes
    [17] = 1.5, -- Service
    [18] = 1.5, -- Emergency
    [19] = 1.5, -- Military
    [20] = 1.8, -- Commercial
    [21] = 0.0  -- Trains (no fuel)
}
