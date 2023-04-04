ENTITY = FindMetaTable("Entity")
PLAYER = FindMetaTable("Player")

GM.Name = "Gmod Wars"
GM.Author = "Reece™"
GM.Description = "A light weight rts gamemode, made during my free time."

gmodwars.util.IncludeDirectory("core/derma")
gmodwars.util.IncludeDirectory("core/libs")
gmodwars.util.IncludeDirectory("core/meta")
gmodwars.util.IncludeDirectory("core/hooks")

function GM:Initialize()
end

function GM:OnReloaded()
end