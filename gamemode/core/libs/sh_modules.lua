minerva.modules = minerva.modules or {}
minerva.modules.stored = {}

function minerva.modules:Register(info)
    if ( !info ) then
        minerva.util:PrintError("Attempted to register an invalid module!")
        return
    end

    if ( !info.Name ) then
        info.Name = "Unknown"
    end

    if ( !info.Description ) then
        info.Description = "No description provided."
    end

    if ( !info.Author ) then
        info.Author = "Unknown"
    end

    local uniqueID = string.lower(string.gsub(info.Name, "%s", "_")) 
    info.UniqueID = uniqueID

    info.Index = table.Count(minerva.modules.stored) + 1

    minerva.modules.stored[info.Index] = info

    return info.Index
end

function minerva.modules:Get(identifier)
    if not ( identifier ) then
        minerva.util:PrintError("Attempted to get an invalid module!")
        return
    end

    if ( minerva.modules.stored[identifier] ) then
        return minerva.modules.stored[identifier]
    end

    for k, v in pairs(minerva.modules.stored) do
        if ( string.find(string.lower(v.Name), string.lower(identifier)) ) then
            return v
        elseif ( string.find(string.lower(v.UniqueID), string.lower(identifier)) ) then
            return v
        end
    end
end

function minerva.modules:LoadFolder(path, bFromLua)
    local baseDir = engine.ActiveGamemode()
    baseDir = baseDir .. "/gamemode/"

    if ( bFromLua ) then
        baseDir = ""
    end

    // Load modules from the main folder
    for k, v in ipairs(file.Find(baseDir .. path .. "/*.lua", "LUA")) do
        minerva.util:LoadFile(path .. "/" .. v)
    end

    // Load modules from subfolders
    local files, folders = file.Find(baseDir .. path .. "/*", "LUA")
    for k, v in ipairs(folders) do
        local modulePath = baseDir .. path .. "/" .. v .. "/sh_module.lua"

        if ( file.Exists(modulePath, "LUA") ) then
            minerva.util:LoadFile(modulePath, true)
        end
    end

    return true
end