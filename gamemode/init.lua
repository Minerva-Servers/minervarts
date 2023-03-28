DeriveGamemode("sandbox")

gmodwars = gmodwars or {}

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("core/sh_util.lua")
AddCSLuaFile("shared.lua")

include("core/sh_util.lua")
include("shared.lua")