GM.Name = "Real Time Strategy"
GM.Author = "Riggs"
GM.Description = "A real time strategy game mode for Garry's Mod. Created by Riggs for Minerva Servers."
GM.Version = "Pre-Alpha"

// Include the core files
minerva:LoadFolder("core/config")
minerva:LoadFolder("core/util")
minerva:LoadFolder("core/thirdparty")
minerva:LoadFolder("core/libs")
minerva:LoadFolder("core/meta")
minerva:LoadFolder("core/derma")
minerva:LoadFolder("core/hooks")
minerva:LoadFolder("core/net")
minerva.modules:LoadFolder("core/modules")
minerva.gamemodes:LoadFolder("core/gamemodes")

function GM:Initialize()
    minerva:LoadSchema()
end

minerva_reloaded = false
minerva_refreshes = minerva_refreshes or 0

function GM:OnReloaded()
    game.CleanUpMap()
    
    if ( minerva_reloaded ) then
        return
    end

    minerva_reloaded = true

    minerva:LoadSchema()

    minerva_refreshes = minerva_refreshes + 1
end

minerva:LoadFile("core/sh_commands.lua")

concommand.Remove("gm_save")
concommand.Add("gm_save", function(ply, command, arguments)
    minerva:PrintError("This command has been disabled.", ply)
end)

concommand.Remove("gmod_admin_cleanup")
concommand.Add("gmod_admin_cleanup", function(ply, command, arguments)
    minerva:PrintError("This command has been disabled. Please refresh the server or restart the server instead.", ply)
end)