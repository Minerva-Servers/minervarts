minerva.abilities = minerva.abilities or {}
minerva.abilities.stored = minerva.abilities.stored or {}

function minerva.abilities.Get(abilityIndex)
    return minerva.abilities.stored[abilityIndex]
end

function minerva.abilities.GetAll()
    return minerva.abilities.stored
end

function minerva.abilities.Register(abilityData)
    local abilityDataIndex = #minerva.abilities.stored + 1
    abilityData.index = abilityDataIndex

    minerva.abilities.stored[abilityData.uniqueID] = abilityData

    return abilityDataIndex
end

minerva.util.IncludeDirectory("minervawars/gamemode/abilities", true)