gmodwars.abilities = gmodwars.abilities or {}
gmodwars.abilities.stored = gmodwars.abilities.stored or {}

function gmodwars.abilities.Get(abilityIndex)
    return gmodwars.abilities.stored[abilityIndex]
end

function gmodwars.abilities.GetAll()
    return gmodwars.abilities.stored
end

function gmodwars.abilities.Register(abilityData)
    local abilityDataIndex = #gmodwars.abilities.stored + 1
    abilityData.index = abilityDataIndex

    gmodwars.abilities.stored[#gmodwars.abilities.stored + 1] = abilityData

    return abilityDataIndex
end

gmodwars.util.IncludeDirectory("gmodwars/gamemode/abilities", true)