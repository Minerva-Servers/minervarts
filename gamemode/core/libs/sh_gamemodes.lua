minerva.gamemodes = minerva.gamemodes or {}
minerva.gamemodes.stored = {}

function minerva.gamemodes:Register(info)
    if ( !info ) then
        minerva.util:PrintError("Attempted to register an invalid gamemode!")
        return
    end

    if ( !info.Name ) then
        minerva.util:PrintError("Attempted to register a gamemode with no name!")
        return
    end

    if ( !info.Description ) then
        minerva.util:PrintError("Attempted to register a gamemode with no description!")
        return
    end

    local uniqueID = string.lower(string.gsub(info.Name, "%s", "_"))
    info.UniqueID = uniqueID

    info.Index = table.Count(self.stored) + 1

    self.stored[info.Index] = info

    minerva.util:PrintMessage("Registered gamemode " .. info.Name .. "!")

    return info.Index
end

function minerva.gamemodes:Get(identifier)
    if ( !identifier ) then
        minerva.util:PrintError("Attempted to get an invalid gamemode!")
        return
    end

    if ( self.stored[identifier] ) then
        return self.stored[identifier]
    end

    for k, v in pairs(self.stored) do
        if ( v.Index == tonumber(identifier) ) then
            return v
        elseif ( minerva.util.FindText(v.Name, identifier) ) then
            return v
        elseif ( minerva.util.FindText(v.UniqueID, identifier) ) then
            return v
        end
    end
end

function minerva.gamemodes:GetAll()
    return self.stored
end

function minerva.gamemodes:GetRandom()
    local stored = self:GetAll()
    return stored[math.random(1, #stored)].Index
end

function minerva.gamemodes:GetCurrent()
    return GetNetVar("gamemode", NULL)
end

function minerva.gamemodes:SetCurrent(identifier)
    if ( !identifier ) then
        minerva.util:PrintError("Attempted to set an invalid gamemode!")
        return
    end

    local gm = self:Get(identifier)
    if ( !gm ) then
        minerva.util:PrintError("Attempted to set an invalid gamemode!")
        return
    end

    if ( gm == self:GetCurrent() ) then
        return
    end

    local oldGM = self:GetCurrent()
    if ( oldGM ) then
        local oldGMData = self:Get(oldGM)
        if ( oldGMData and oldGMData.OnEnd ) then
            oldGMData:OnEnd()
        end
    end

    hook.Run("PreGamemodeChanged", oldGM, gm.Index)

    game.CleanUpMap()
    SetNetVar("gamemode", gm.Index)

    if ( gm.OnStart ) then
        gm:OnStart()
    end

    hook.Run("PostGamemodeChanged", oldGM, gm.Index)

    return true
end

function minerva.gamemodes:LoadGamemodes()
    local path = engine.ActiveGamemode() .. "/gamemodes"

    minerva.util:PrintMessage("Searching for gamemodes...")

    local files, folders = file.Find(path .. "/*", "LUA")
    if ( !files and !folders ) then
        minerva.util:PrintError("No gamemodes found!")
        return
    end

    for k, v in ipairs(folders) do
        local bSuccess = minerva.util:LoadFolder(path .. "/" .. v, true)
        if ( !bSuccess ) then
            minerva.util:PrintError("Failed to load gamemode " .. v .. "!")
        end
    end

    minerva.util:PrintMessage("Gamemodes loaded!")
end