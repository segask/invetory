let inventoryOpen = false;

window.addEventListener('message', function(event) {
    if (event.data.action === 'openInventory') {
        document.getElementById('inventory').style.display = 'block';
        loadInventory(event.data.inventory);
        inventoryOpen = true;
    }
});

function loadInventory(inventory) {
    const slots = document.getElementById('slots');
    slots.innerHTML = '';
    for (let i = 1; i <= 50; i++) {
        const slot = document.createElement('div');
        slot.className = 'slot';
        slot.dataset.slot = i;
        if (inventory[i]) {
            slot.textContent = inventory[i].item + ' (' + inventory[i].count + ')';
        }
        slots.appendChild(slot);
    }
}

function closeInventory() {
    fetch('https://invetory/closeInventory', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
    document.getElementById('inventory').style.display = 'none';
    inventoryOpen = false;
}

// Закрытие по кнопке
document.getElementById('close').addEventListener('click', function() {
    closeInventory();
});

// Закрытие по ESC
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape' && inventoryOpen) {
        closeInventory();
    }
});