FlameEconomy = {}
FlameEconomy.Config = {}

if SERVER then
    AddCSLuaFile("flame_economy/sh_config.lua")
    AddCSLuaFile("flame_economy/cl_init.lua")
    AddCSLuaFile("flame_economy/sh_apinator.lua")
    AddCSLuaFile("flame_economy/sh_hook.lua")

    include("flame_economy/sh_config.lua")
    include("flame_economy/sh_hook.lua")
    include("flame_economy/sh_apinator.lua")
else
    include("flame_economy/sh_config.lua")
    include("flame_economy/cl_init.lua")
    include("flame_economy/sh_apinator.lua")
    include("flame_economy/sh_hook.lua")
end