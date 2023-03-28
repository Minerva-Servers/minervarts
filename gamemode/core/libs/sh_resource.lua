gmodwars.resources = gmodwars.resources or {}
gmodwars.resources.stored = gmodwars.resources.stored or {}

function gmodwars.resources.Get(name)
    return gmodwars.resources.stored[name]
end

function gmodwars.resources.GetAll()
    return gmodwars.resources.stored
end

function gmodwars.resources.Register(resourceData)
    local resourceDataIndex = #gmodwars.resources.stored + 1
    resourceData.index = resourceDataIndex

    gmodwars.resources.stored[#gmodwars.resources.stored + 1] = resourceData

    return resourceDataIndex
end

gmodwars.util.IncludeDirectory("gmodwars/gamemode/resources", true)