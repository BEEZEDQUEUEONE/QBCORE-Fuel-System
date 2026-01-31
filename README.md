# QBCore Fuel System

A comprehensive fuel system for FiveM servers running QBCore Framework with a clean, modern UI.

## Features

✨ **Core Functionality**
- Realistic fuel consumption based on vehicle speed and RPM
- Different consumption rates for different vehicle classes
- Fuel gauge HUD display
- 28+ gas station locations across the map
- Blips for gas stations on the map

⚡ **Electric Vehicles**
- Support for electric vehicles with charging stations
- Different pricing for electricity vs fuel
- Custom charging animations and UI
- Configurable electric vehicle list

🛢️ **Jerry Can System**
- Buy jerry cans at gas stations
- Refill vehicles with jerry cans when not at a station
- Jerry can has limited capacity (20L default)
- Refillable jerry cans

💰 **Payment System**
- Integrated with QBCore economy
- Pays from cash first, then bank
- Dynamic pricing based on fuel added
- Separate pricing for fuel and electricity

🎨 **Clean UI**
# Modern, sleek fuel gauge
# Animated refueling interface
- # Color-coded fuel levels (green → yellow → red)
- # Smooth animations and transitions
- # Electric vehicle specific UI elements

## Installation

### Step 1: Download from GitHub
1. Go to the repository: https://github.com/BEEZEDQUEUEONE/QBCORE-Fuel-System
2. Click the green **Code** button
3. Select **Download ZIP**
4. Extract the ZIP file - you'll get a folder named `QBCORE-Fuel-System-main`

### Step 2: Rename and Move to Server
1. Rename `QBCORE-Fuel-System-main` to `qb-fuel` (or your preferred name)
2. Copy the renamed folder to your server's `resources` directory
   - Example path: `server/resources/[qb]/qb-fuel/`
3. Verify all files are present inside the folder:
   - `fxmanifest.lua`, `config.lua`, `client.lua`, `server.lua`, `README.md`
   - `html/` folder containing `index.html`, `style.css`, `script.js`

### Step 3: Configure server.cfg
1. Open your `server.cfg` file
2. Add the resource to your startup:
   ```cfg
   ensure qb-fuel
   ```
   - Place it after `ensure qb-core` and `ensure qb-inventory`

### Step 4: Add Jerry Can Item to QBCore
1. Navigate to your QBCore shared items file:
   - Path: `qb-core/shared/items.lua`
2. Open the file and add this item definition:
   ```lua
   ['jerrycan'] = {
       ['name'] = 'jerrycan',
       ['label'] = 'Jerry Can',
       ['weight'] = 5000,
       ['type'] = 'item',
       ['image'] = 'jerrycan.png',
       ['unique'] = true,
       ['useable'] = true,
       ['shouldClose'] = true,
       ['combinable'] = nil,
       ['description'] = 'A can full of fuel'
   },
   ```
3. Save the file

### Step 5: Add Jerry Can Image
1. Find or create a `jerrycan.png` image (256x256 recommended)
2. Add it to your inventory images folder:
   - Path: `qb-inventory/html/images/jerrycan.png`
3. Make sure the filename matches exactly: `jerrycan.png`

### Step 6: Configure the Script (Optional)
1. Open `config.lua` in the fuel script folder
2. Adjust settings as needed:
   - Fuel prices (`Config.FuelPrice`)
   - Refuel speed (`Config.RefuelSpeed`)
   - Consumption rate (`Config.FuelConsumption`)
   - Gas station locations
   - Electric vehicle models
3. Save your changes

### Step 7: Restart Server
1. Stop your FiveM server completely
2. Start the server
3. Watch console for any errors during startup
4. Look for: `[qb-fuel] Resource started successfully`

### Step 8: Test In-Game
1. Join your server
2. Spawn a vehicle
3. Check if fuel gauge appears (bottom-right by default)
4. Drive to a gas station (check map for blips)
5. Press `E` to test refueling
6. Test jerry can purchase at station
7. Use `/togglefuelhud` command to verify it works

### Troubleshooting
- **No fuel gauge showing**: Check console for errors, ensure `Config.ShowFuelHUD = true`
- **Can't refuel**: Make sure you're within range of a gas station
- **Jerry can not working**: Verify item was added correctly to `qb-core/shared/items.lua`
- **Blips not showing**: Set `Config.ShowBlips = true` in config
- **Payment not working**: Ensure QBCore money system is working properly

## Configuration

Edit `config.lua` to customize:

- **Fuel prices** - Adjust cost per liter
- **Refuel speed** - How fast vehicles refuel
- **Consumption rate** - How quickly fuel depletes
- **Gas station locations** - Add/remove stations
- **Electric vehicles** - Add custom electric vehicle models
- **Jerry can settings** - Capacity and pricing
- **HUD settings** - Position and visibility

## Usage

### For Players

**Refueling at Gas Stations:**
1. Drive to a gas station (marked on map)
2. Press `E` to start refueling
3. Wait for tank to fill
4. Press `BACKSPACE` to stop early
5. Payment is automatic

**Using Jerry Cans:**
1. Buy a jerry can at a gas station
2. Approach any vehicle
3. Press `G` to refuel from jerry can
4. Jerry can depletes as you use it
5. Refill jerry can at gas stations

**Commands:**
- `/togglefuelhud` - Show/hide the fuel gauge

### For Developers

**Exports:**

```lua
-- Get vehicle fuel level
local fuel = exports['qb-fuel']:GetFuel(vehicle)

-- Set vehicle fuel level
exports['qb-fuel']:SetFuel(vehicle, amount)
```

## Customization

### Adding Gas Stations
Edit `config.lua` and add to `Config.GasStations`:
```lua
{coords = vector3(x, y, z), heading = 0.0, name = "Station Name"}
```

### Adding Electric Vehicles
Edit `config.lua` and add to `Config.ElectricVehicles`:
```lua
"modelname"
```

### Adjusting Fuel Consumption
Edit `Config.ClassConsumption` in `config.lua` to adjust consumption per vehicle class.

## Credits

Created for QBCore Framework
Compatible with QBCore inventory system

## Support

For issues or questions, please create an issue on the GitHub repository.

## License

Free to use for your FiveM server, but do not modify or redistribute.
