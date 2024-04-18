GM.Name = "Real Time Strategy"
GM.Author = "Riggs"
GM.Description = "A real time strategy game mode for Garry's Mod. Created by Riggs for Minerva Servers."
GM.Version = "Pre-Alpha"

minerva:LoadFolder("core/thirdparty")
minerva:LoadFolder("core/libs")
minerva:LoadFolder("core/meta")
minerva:LoadFolder("core/derma")
minerva:LoadFolder("core/hooks")
minerva:LoadFolder("core/net")
minerva:LoadFolder("core/modules")

minerva:LoadFile("core/sh_commands.lua")

function GM:Initialize()
    minerva:PrintMessage("Initializing gamemode.")
    minerva:LoadSchema()

    hook.Run("MinervaInitialized")
end

minerva_reloaded = nil

function GM:OnReloaded()
    if ( minerva_reloaded ) then
        return
    end

    minerva_reloaded = true

    minerva:PrintMessage("Reloading gamemode.")
    minerva:LoadSchema()

    hook.Run("MinervaReloaded")
end