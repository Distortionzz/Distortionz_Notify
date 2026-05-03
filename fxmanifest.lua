fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Distortionz'
description 'Premium custom notification system for Distortionz RP'
version '1.0.3'
repository 'https://github.com/Distortionzz/Distortionz_Notify'

ui_page 'html/index.html'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'version_check.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/app.js'
}