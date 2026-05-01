window.addEventListener('message', function(event) {
    if (event.data.action === 'openInventory') {
        document.getElementById('inventory').style.display = 'block';
        loadInventory(event.data.inventory);
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

document.getElementById('close').addEventListener('click', function() {
    fetch('https://invetory/closeInventory', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
    document.getElementById('inventory').style.display = 'none';
});