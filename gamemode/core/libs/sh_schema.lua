// @schema loading

SCHEMA = {}

local defaultSchema = {
    Name = "Unknown",
    Description = "No description available.",
    Author = "Unknown",
}

function minerva:LoadSchema()
    local path = "minervarts/schema/sh_schema.lua"
    local bSuccess = false

    if ( file.Exists(path, "LUA") ) then
        bSuccess = minerva:LoadFolder("minervarts/schema", true)
    end

    if not ( bSuccess ) then
        minerva:PrintError("Schema not found!")
        return
    end

    hook.Run("SchemaLoad", path)

    for k, v in pairs(defaultSchema) do
        if not ( SCHEMA[k] ) then
            SCHEMA[k] = v
        end
    end

    minerva:PrintMessage("Loaded schema " .. SCHEMA.Name)

    minerva.units:LoadFolder("schema/factions")
    minerva.units:LoadFolder("schema/units")

    hook.Run("SchemaLoaded", path, SCHEMA)

    return true
end