DeriveGamemode("sandbox")

minerva = minerva or {util = {}, meta = {}}

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("core/sh_util.lua")
AddCSLuaFile("shared.lua")

include("core/sh_util.lua")
include("shared.lua")