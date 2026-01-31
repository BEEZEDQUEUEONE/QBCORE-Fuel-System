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

- Modern, sleek fuel gauge
- Animated refueling interface
- Color-coded fuel levels (green → yellow → red)
- Smooth animations and transitions
- Electric vehicle specific UI elements

## Installation

### Step 1: Download and Extract
1. Download the fuel system files
2. Extract the `fivem-fuel` folder
3. Rename it to your preference (e.g., `qb-fuel`)

### Step 2: Add to Server Resources
1. Copy the renamed folder to your server's `resources` directory
   - Example path: `server/resources/[qb]/qb-fuel/`

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

Free to use and modify for your FiveM server.

## Publishing to GitHub

### Prerequisites
- Git installed on your computer
- GitHub account created
- All files tested and working on your server

### Step 1: Initialize Git Repository

1. Open PowerShell/Terminal in the `fivem-fuel` folder
2. Initialize git repository:
   ```bash
   git init
   ```

3. Create a `.gitignore` file (optional but recommended):
   ```bash
   New-Item .gitignore
   ```

4. Add this to `.gitignore`:
   ```
   # OS Files
   .DS_Store
   Thumbs.db
   
   # IDE Files
   .vscode/
   .idea/
   
   # Backup files
   *.bak
   *~
   ```

### Step 2: Create GitHub Repository

1. Go to [GitHub.com](https://github.com)
2. Click the **+** icon in top-right corner
3. Select **New repository**
4. Fill in repository details:
   - **Name**: `qb-fuel` (or your preferred name)
   - **Description**: "QBCore Fuel System with modern UI for FiveM"
   - **Public** or **Private**: Choose based on preference
   - **DO NOT** initialize with README (you already have one)
5. Click **Create repository**

### Step 3: Verify Files Locally

Make sure all files are present:
```bash
Get-ChildItem -Recurse
```

You should see:
- `fxmanifest.lua`
- `config.lua`
- `client.lua`
- `server.lua`
- `README.md`
- `html/index.html`
- `html/style.css`
- `html/script.js`

### Step 4: Commit Files

1. Add all files to staging:
   ```bash
   git add .
   ```

2. Commit with message:
   ```bash
   git commit -m "Initial commit: QBCore fuel system with modern UI"
   ```

### Step 5: Push to GitHub

1. Add remote repository (replace `YOUR_USERNAME` and `REPO_NAME`):
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
   ```

2. Rename branch to main (if needed):
   ```bash
   git branch -M main
   ```

3. Push to GitHub:
   ```bash
   git push -u origin main
   ```

4. Enter your GitHub credentials when prompted

### Step 6: Verify Upload

1. Go to your GitHub repository URL
2. Verify all files are visible
3. Check that README displays correctly
4. Test clone/download functionality

### Step 7: Add Release (Optional)

1. Go to your repository on GitHub
2. Click **Releases** on the right sidebar
3. Click **Create a new release**
4. Fill in:
   - **Tag version**: `v1.0.0`
   - **Release title**: `Initial Release - QBCore Fuel System`
   - **Description**: List features and installation notes
5. Click **Publish release**

### Updating the Repository

When you make changes:

```bash
# Check what changed
git status

# Add changes
git add .

# Commit with descriptive message
git commit -m "Description of changes"

# Push to GitHub
git push
```

### Repository Best Practices

- ✅ Write clear commit messages
- ✅ Test all changes before pushing
- ✅ Update version numbers in releases
- ✅ Keep README.md up to date
- ✅ Respond to issues and pull requests
- ✅ Add screenshots/videos to README (optional)
- ✅ Include changelog for updates
