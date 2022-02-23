fx_version "cerulean"
game "gta5"
lua54 "yes"

client_scripts{
    "shared_config.lua",

    "modules/**/sh_*.lua",

    "client/*.lua",
    "client/utils/*.lua",
    "modules/**/cl_*.lua",
    "modules/admin/freecam/*.lua",

    "i0bl439n8/cl_*.lua",

    "ui/*.lua"
}

server_scripts{
	"@mysql-async/lib/MySQL.lua",
    "shared_config.lua",

    "modules/**/sh_*.lua",

    "server/*.lua",
    "server/utils/rb6yvk0.lua",
    "modules/**/sv_*.lua",

    "i0bl439n8/sv_*.lua"
}

ui_page "ui/index.html"
file "ui/index.html"


dependency "mysql-async"