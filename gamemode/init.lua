local DeriveGamemode = DeriveGamemode
local AddCSLuaFile = AddCSLuaFile
local include = include

DeriveGamemode("base")

minerva = minerva or {}

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("core/sh_util.lua")
AddCSLuaFile("shared.lua")

include("core/sh_util.lua")
include("shared.lua")