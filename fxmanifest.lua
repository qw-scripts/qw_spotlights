fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'

description 'spotlight resource for FiveM'
author 'qw-scripts'
version '0.1.0'

client_scripts {
    'client/**/*'
}

server_scripts {
    'server/**/*'
}

shared_scripts {
    '@ox_lib/init.lua'
}

lua54 'yes'
