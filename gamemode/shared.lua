ENTITY = FindMetaTable("Entity")
PLAYER = FindMetaTable("Player")

GM.Name = "Minerva Wars"
GM.Author = "Riggs"
GM.Description = "A light weight rts gamemode, made during my free time."

minerva.util.IncludeDirectory("core/derma")
minerva.util.IncludeDirectory("core/libs")
minerva.util.IncludeDirectory("core/meta")
minerva.util.IncludeDirectory("core/hooks")

function GM:Initialize()
end

function GM:OnReloaded()
end
