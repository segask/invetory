fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Custom Inventory System for FiveM'
version '1.0.0'

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

shared_scripts {
    'shared/shared.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'es_extended',
    'oxmysql'
}