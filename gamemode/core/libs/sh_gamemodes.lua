// Custom gamemode system for the framework, allows for easy gamemode switching and management such as Free For All, Team Deathmatch, etc.

minerva.gamemodes = minerva.gamemodes or {}
minerva.gamemodes.stored = {}

function minerva.gamemodes:Register(info)
    if not ( info ) then
        minerva:PrintError("Attempted to register an invalid gamemode!")
        return
    end

    if not ( info.Name ) then
        minerva:PrintError("Attempted to register a gamemode with no name!")
        return
    end

    if not ( info.Description ) then
        minerva:PrintError("Attempted to register a gamemode with no description!")
        return
    end

    for k, v in pairs(info) do
        if ( type(v) == "function" ) then
            minerva_hooks[k] = minerva_hooks[k] or {}
            minerva_hooks[k][info] = v
        end
    end

    local uniqueID = string.lower(string.gsub(info.Name, "%s", "_"))
    info.UniqueID = uniqueID

    info.Index = table.Count(minerva.gamemodes.stored) + 1

    for k, v in pairs(info) do
        if ( type(v) == "function" ) then
            local function func(self, ...)
                local gm = minerva.gamemodes:GetCurrent()
                if ( gm != info.Index ) then
                    return
                end

                return v(...)
            end

            minerva_hooks[k] = minerva_hooks[k] or {}
            minerva_hooks[k][info] = func
        end
    end

    minerva.gamemodes.stored[info.Index] = info

    return info.Index
end

function minerva.gamemodes:Get(identifier)
    if not ( identifier ) then
        minerva:PrintError("Attempted to get an invalid gamemode!")
        return
    end

    if ( minerva.gamemodes.stored[identifier] ) then
        return minerva.gamemodes.stored[identifier]
    end

    for k, v in pairs(minerva.gamemodes.stored) do
        if ( string.find(string.lower(v.Name), string.lower(identifier)) ) then
            return v
        elseif ( string.find(string.lower(v.UniqueID), string.lower(identifier)) ) then
            return v
        end
    end
end

function minerva.gamemodes:AddFunction(gm, hook, func)
    if not ( gm ) then
        minerva:PrintError("Attempted to add a function to an invalid gamemode!")
        return
    end

    if not ( hook ) then
        minerva:PrintError("Attempted to add a function to an invalid hook!")
        return
    end

    if not ( func ) then
        minerva:PrintError("Attempted to add an invalid function!")
        return
    end

    local gamemodeInfo = minerva.gamemodes:Get(gm)
    if not ( gamemodeInfo ) then
        minerva:PrintError("Attempted to add a function to an invalid module!")
        return
    end

    local function newfunc(...)
        local gm = minerva.gamemodes:GetCurrent()
        print("Current gamemode: " .. minerva.gamemodes:Get(gm).Name)
        print("Incoming gamemode: " .. gamemodeInfo.Name)
        if ( gm == gamemodeInfo.Index ) then
            minerva:PrintMessage("Called function from gamemode " .. gamemodeInfo.Name .. "!")
            return func(...)
        else
            minerva:PrintError("Attempted to call a function from a gamemode that is not currently active!")
        end
    end

    minerva_hooks[hook] = minerva_hooks[hook] or {}
    minerva_hooks[hook][gamemodeInfo] = newfunc
end

function minerva.gamemodes:LoadFolder(path, bFromLua)
    local baseDir = engine.ActiveGamemode()
    baseDir = baseDir .. "/gamemode/"

    // Load gamemodes from the main folder, doubt this will be used but it's here just in case
    for k, v in ipairs(file.Find(( bFromLua and "" or baseDir ) .. path .. "/*.lua", "LUA")) do
        minerva:LoadFile(path .. "/" .. v)
    end

    // Load gamemodes from subfolders, this is the main use of this function
    local files, folders = file.Find(( bFromLua and "" or baseDir ) .. path .. "/*", "LUA")
    for k, v in ipairs(folders) do
        local gamemodePath = path .. "/" .. v .. "/sh_gamemode.lua"

        if ( file.Exists(gamemodePath, "LUA") ) then
            minerva:LoadFile(gamemodePath, true)
        end
    end

    return true
end

function minerva.gamemodes:GetAll()
    return minerva.gamemodes.stored
end

function minerva.gamemodes:GetRandom()
    local stored = minerva.gamemodes:GetAll()
    return stored[math.random(1, #stored)].Index
end

function minerva.gamemodes:GetCurrent()
    return GetGlobalInt("MinervaGamemode", 1)
end

function minerva.gamemodes:SetCurrent(identifier)
    if not ( identifier ) then
        minerva:PrintError("Attempted to set an invalid gamemode!")
        return
    end

    local gm = minerva.gamemodes:Get(identifier)
    if not ( gm ) then
        minerva:PrintError("Attempted to set an invalid gamemode!")
        return
    end

    if ( gm == minerva.gamemodes:GetCurrent() ) then
        return
    end

    local oldGM = minerva.gamemodes:GetCurrent()
    if ( oldGM ) then
        local oldGMData = minerva.gamemodes:Get(oldGM)
        if ( oldGMData.OnEnd ) then
            oldGMData.OnEnd()
        end
    end

    hook.Run("PreGamemodeChanged", oldGM, gm.Index)

    game.CleanUpMap()
    SetGlobalInt("MinervaGamemode", gm.Index)

    if ( gm.OnStart ) then
        gm.OnStart()
    end

    hook.Run("PostGamemodeChanged", oldGM, gm.Index)

    return true
end