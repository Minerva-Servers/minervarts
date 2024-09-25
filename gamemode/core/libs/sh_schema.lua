minerva.schema = minerva.schema or {}

SCHEMA = {}

local default = {
    Name = "Unknown",
    Description = "No description available.",
    Author = "Unknown",
}

function minerva.schema:LoadSchema()
    local path = engine.ActiveGamemode() .. "/schema/sh_schema.lua"
    local bSuccess = false

    minerva.util:PrintMessage("Searching for schema...")

    if ( file.Exists(path, "LUA") ) then
        bSuccess = minerva.util:LoadFolder(engine.ActiveGamemode() .. "/schema", true)
    end

    if ( !bSuccess ) then
        minerva.util:PrintError("Schema not found!")
        return
    else
        minerva.util:PrintMessage("Schema found, loading " .. SCHEMA.Name .. "...")
    end

    hook.Run("PreSchemaLoad", path, SCHEMA)

    for k, v in pairs(default) do
        if ( !SCHEMA[k] ) then
            SCHEMA[k] = v
        end
    end

    minerva.hooks:Register("SCHEMA")
    minerva.modules:LoadFolder(engine.ActiveGamemode() .. "/schema/modules", true)

    minerva.util:LoadFolder(engine.ActiveGamemode() .. "/schema/attributes", true)
    minerva.util:LoadFolder(engine.ActiveGamemode() .. "/schema/buildings", true)
    minerva.util:LoadFolder(engine.ActiveGamemode() .. "/schema/factions", true)
    minerva.util:LoadFolder(engine.ActiveGamemode() .. "/schema/units", true)

    minerva.util:PrintMessage("Loaded schema " .. SCHEMA.Name)

    hook.Run("PostSchemaLoad", path, SCHEMA)

    return true
end