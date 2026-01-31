window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'updateHUD':
            updateHUD(data);
            break;
        case 'showRefuel':
            showRefuel(data);
            break;
        case 'updateRefuel':
            updateRefuel(data);
            break;
    }
});

function updateHUD(data) {
    const fuelHUD = document.getElementById('fuel-hud');
    const fuelText = document.getElementById('fuel-text');
    const speedText = document.getElementById('speed-text');
    const fuelDisplay = document.querySelector('.fuel-display');
    const hudContainer = document.querySelector('.hud-container');
    
    if (data.show) {
        fuelHUD.classList.remove('hidden');
        
        const fuel = Math.max(0, Math.min(100, data.fuel));
        
        // Add % symbol in big mode
        if (data.hudSize === 'big') {
            fuelText.textContent = Math.floor(fuel) + '%';
            hudContainer.classList.add('big');
        } else {
            fuelText.textContent = Math.floor(fuel);
            hudContainer.classList.remove('big');
        }
        
        // Update speed if provided
        if (data.speed !== undefined) {
            speedText.textContent = Math.floor(data.speed);
        }
        
        // Change color based on fuel level
        fuelDisplay.classList.remove('low', 'medium', 'critical');
        
        if (fuel <= 10) {
            fuelDisplay.classList.add('critical');
        } else if (fuel <= 25) {
            fuelDisplay.classList.add('low');
        } else if (fuel <= 50) {
            fuelDisplay.classList.add('medium');
        }
    } else {
        fuelHUD.classList.add('hidden');
    }
}

function showRefuel(data) {
    const refuelUI = document.getElementById('refuel-ui');
    const refuelTitle = document.getElementById('refuel-title');
    
    if (data.show) {
        refuelUI.classList.remove('hidden');
        refuelTitle.textContent = data.isElectric ? 'CHARGING' : 'REFUELING';
        
        const progress = document.getElementById('refuel-progress');
        const percentage = document.getElementById('refuel-percentage');
        const currentFuel = document.getElementById('current-fuel');
        
        const fuel = Math.max(0, Math.min(100, data.fuel));
        progress.style.width = fuel + '%';
        percentage.textContent = fuel + '%';
        currentFuel.textContent = fuel + '%';
        
        // Update icon for electric vehicles
        const icon = document.querySelector('.refuel-icon svg path');
        if (data.isElectric) {
            // Electric icon (battery)
            icon.setAttribute('d', 'M16,18H8V6H16M16.67,4H15V2H9V4H7.33A1.33,1.33 0 0,0 6,5.33V20.67C6,21.4 6.6,22 7.33,22H16.67A1.33,1.33 0 0,0 18,20.67V5.33C18,4.6 17.4,4 16.67,4Z');
            progress.style.background = 'linear-gradient(90deg, #00ff88, #00ff00)';
        } else {
            // Gas pump icon
            icon.setAttribute('d', 'M19.77,7.23L19.78,7.22L16.06,3.5L15,4.56L17.11,6.67C16.17,7.03 15.5,7.93 15.5,9A2.5,2.5 0 0,0 18,11.5C18.36,11.5 18.69,11.42 19,11.29V18.5A1,1 0 0,1 18,19.5A1,1 0 0,1 17,18.5V14A2,2 0 0,0 15,12H14V5A2,2 0 0,0 12,3H6A2,2 0 0,0 4,5V21H14V13.5H15.5V18.5A2.5,2.5 0 0,0 18,21A2.5,2.5 0 0,0 20.5,18.5V9C20.5,8.31 20.22,7.68 19.77,7.23M18,10A1,1 0 0,1 17,9A1,1 0 0,1 18,8A1,1 0 0,1 19,9A1,1 0 0,1 18,10M6,5H12V11H6V5Z');
            progress.style.background = 'linear-gradient(90deg, #00ff88, #00d4ff)';
        }
    } else {
        refuelUI.classList.add('hidden');
    }
}

function updateRefuel(data) {
    const progress = document.getElementById('refuel-progress');
    const percentage = document.getElementById('refuel-percentage');
    const currentFuel = document.getElementById('current-fuel');
    
    const fuel = Math.max(0, Math.min(100, data.fuel));
    progress.style.width = fuel + '%';
    percentage.textContent = fuel + '%';
    currentFuel.textContent = fuel + '%';
}

// Handle ESC key to close refuel UI
document.addEventListener('keyup', function(event) {
    if (event.key === 'Escape') {
        const refuelUI = document.getElementById('refuel-ui');
        if (!refuelUI.classList.contains('hidden')) {
            fetch(`https://${GetParentResourceName()}/closeRefuel`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            });
        }
    }
});

function GetParentResourceName() {
    let url = window.location.href;
    let match = url.match(/https?:\/\/(.*?)\/nui\/(.*?)\/html/);
    return match ? match[2] : 'unknown';
}
