minerva.resources = minerva.resources or {}
minerva.resources.stored = minerva.resources.stored or {}

function minerva.resources.Get(name)
    return minerva.resources.stored[name]
end

function minerva.resources.GetAll()
    return minerva.resources.stored
end

function minerva.resources.Register(resourceData)
    local resourceDataIndex = #minerva.resources.stored + 1
    resourceData.index = resourceDataIndex

    minerva.resources.stored[#minerva.resources.stored + 1] = resourceData

    return resourceDataIndex
end

minerva.util.IncludeDirectory("minervawars/gamemode/resources", true)