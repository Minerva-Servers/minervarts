minerva.maps = minerva.maps or {}
minerva.maps.stored = minerva.maps.stored or {}

function minerva.maps:Register(name, data)
    self.stored[name] = data
end

function minerva.maps:Get(name)
    if ( !name ) then
        name = game.GetMap()
    end

    return self.stored[name]
end

function minerva.maps:GetAll()
    return self.stored
end

function minerva.maps:LoadMaps()
    local path = engine.ActiveGamemode() .. "/maps"
    local bSuccess = false

    minerva.util:PrintMessage("Searching for map configs...")

    if ( file.Exists(path, "LUA") ) then
        bSuccess = minerva.util:LoadFolder(engine.ActiveGamemode() .. "/maps", true)
    end

    if ( !bSuccess ) then
        minerva.util:PrintError("No map configs found!")
        return
    else
        minerva.util:PrintMessage("Map configs found, searching for current map config...")
    end

    local map = game.GetMap()
    local data = self:Get(map)

    if ( !data ) then
        minerva.util:PrintError("Map config not found!")
        return
    else
        minerva.util:PrintMessage("Map config found, loading " .. data.Name .. "...")
    end
end