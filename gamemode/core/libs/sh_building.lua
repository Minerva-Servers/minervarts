gmodwars.buildings = gmodwars.buildings or {}
gmodwars.buildings.stored = {}

function gmodwars.buildings.Get(buildingIndex)
    return gmodwars.buildings.stored[buildingIndex]
end

function gmodwars.buildings.GetAll()
    return gmodwars.buildings.stored
end

function gmodwars.buildings.Register(buildingData)
    if not ( buildingData.name ) then
        error("No name provided for building "..#buildingData.."!")
    end

    if not ( buildingData.model ) then
        error("No model provided for building "..buildingData.name.."!")
    end

    local buildingDataIndex = #gmodwars.buildings.stored + 1
    buildingData.index = buildingDataIndex

    gmodwars.buildings.stored[#gmodwars.buildings.stored + 1] = buildingData

    return buildingDataIndex
end

if ( SERVER ) then
    function gmodwars.buildings.Create(buildingIndex, callback)
        local buildingTable = gmodwars.buildings.Get(buildingIndex)

        local building = ents.Create("gmodwars_building")
        building:Spawn()
        building:SetBuildingIndex(buildingIndex)
        building:SetModel(buildingTable.model)
        building:PhysicsInit(SOLID_BBOX)
        building:SetSolid(SOLID_BBOX)

        if ( callback ) then
            callback(building)
        end
    end
end

gmodwars.util.IncludeDirectory("gmodwars/gamemode/buildings", true)