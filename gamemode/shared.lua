GM.Name = "Real Time Strategy"
GM.Author = "Riggs"
GM.Description = "A real time strategy game mode for Garry's Mod. Created by Riggs for Minerva Servers."
GM.Version = "Pre-Alpha"

// Include the core files
minerva.util:LoadFolder("core/config")
minerva.util:LoadFolder("core/util")
minerva.util:LoadFolder("core/thirdparty")
minerva.util:LoadFolder("core/libs")
minerva.util:LoadFolder("core/meta")
minerva.util:LoadFolder("core/derma")
minerva.util:LoadFolder("core/hooks")
minerva.util:LoadFolder("core/net")

minerva.modules:LoadFolder("core/modules")

function GM:Initialize()
    minerva.gamemodes:LoadGamemodes()
    minerva.schema:LoadSchema()
    minerva.maps:LoadMaps()

    hook.Run("LoadFonts")
end

minerva_reloaded = false
minerva_refreshes = minerva_refreshes or 0
minerva_refresh_time = SysTime()

function GM:OnReloaded()
    if ( minerva_reloaded ) then return end

    minerva_reloaded = true

    minerva.gamemodes:LoadGamemodes()
    minerva.schema:LoadSchema()
    minerva.maps:LoadMaps()
    
    hook.Run("LoadFonts")

    minerva_refreshes = minerva_refreshes + 1
    minerva_refresh_time = SysTime() - minerva_refresh_time

    minerva.util:PrintMessage("Reloaded Files (Refreshes: " .. minerva_refreshes .. ", Time: " .. minerva_refresh_time .. "s)")
end

minerva.util:LoadFile("core/sh_commands.lua")

concommand.Remove("gm_save")
concommand.Add("gm_save", function(ply, command, arguments)
    minerva.util:PrintError("This command has been disabled.", ply)
end)

concommand.Remove("gm_admin_cleanup")
concommand.Add("gm_admin_cleanup", function(ply, command, arguments)
    minerva.util:PrintError("This command has been disabled.", ply)
end)