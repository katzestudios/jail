fx_version 'cerulean'
game 'gta5'

description 'A Innovative Free Jail System'

version '1.0.0'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'functions/sv-functions.lua',
    'server.lua',
    'ui/ui-sv.lua'
}

client_scripts {
    'functions/cl-functions.lua',
    'client.lua',
    'ui/ui-cl.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@ox_target',
    'Config.lua',
    '@es_extended/imports.lua'
}

ui_page 'nui/index.html'

files {
    'nui/index.html'
}
dependencies {
    'es_extended'
}

lua54 'yes'