local minerva = minerva

minerva.gamerules = minerva.gamerules or {}
minerva.gamerules.stored = minerva.gamerules.stored or {}

function minerva.gamerules.Get(gameruleIndex)
    return minerva.gamerules.stored[gameruleIndex]
end

function minerva.gamerules.GetAll()
    return minerva.gamerules.stored
end

function minerva.gamerules.Register(gameruleData)
    local gameruleDataIndex = #minerva.gamerules.stored + 1
    gameruleData.index = gameruleDataIndex

    minerva.gamerules.stored[#minerva.gamerules.stored + 1] = gameruleData

    return gameruleDataIndex
end

minerva.util.IncludeDirectory("minervawars/gamemode/gamerules", true)