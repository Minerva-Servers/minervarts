gmodwars.gamerules = gmodwars.gamerules or {}
gmodwars.gamerules.stored = gmodwars.gamerules.stored or {}

function gmodwars.gamerules.Get(gameruleIndex)
    return gmodwars.gamerules.stored[gameruleIndex]
end

function gmodwars.gamerules.GetAll()
    return gmodwars.gamerules.stored
end

function gmodwars.gamerules.Register(gameruleData)
    local gameruleDataIndex = #gmodwars.gamerules.stored + 1
    gameruleData.index = gameruleDataIndex

    gmodwars.gamerules.stored[#gmodwars.gamerules.stored + 1] = gameruleData

    return gameruleDataIndex
end

gmodwars.util.IncludeDirectory("gmodwars/gamemode/gamerules", true)