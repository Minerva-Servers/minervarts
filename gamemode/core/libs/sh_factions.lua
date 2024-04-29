minerva.factions = minerva.factions or {}
minerva.factions.stored = {}

function minerva.factions:Register(info)
    hook.Run("PreFactionRegister", info)

    local UniqueID = string.lower(string.gsub(info.Name, "%s", "_"))
    UniqueID = info.UniqueID or UniqueID

    info.UniqueID = UniqueID

    if ( minerva.factions.stored[info.UniqueID] ) then
        minerva:PrintWarning("Faction \"" .. info.Name .. "\" already exists! Overwriting...")
        minerva.factions.stored[info.UniqueID] = nil
    end

    info.Index = #minerva.factions.stored + 1

    team.SetUp(info.Index, info.Name, info.Color or Color(255, 255, 255))

    minerva.factions.stored[info.Index] = info

    hook.Run("FactionRegistered", info)

    return info.Index
end

function minerva.factions:Get(identifier)
    if not ( identifier ) then
        minerva:PrintError("Attempted to get an invalid faction!")
        return
    end

    for k, v in pairs(minerva.factions.stored) do
        if ( string.find(string.lower(v.UniqueID), string.lower(identifier)) ) then
            return v
        end
    end

    if ( istable(identifier) ) then
        identifier = identifier.Name
    end

    if ( minerva.factions.stored[identifier] ) then
        return minerva.factions.stored[identifier]
    end
end

function minerva.factions:GetAll()
    return minerva.factions.stored
end