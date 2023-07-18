local error = error
local minerva = minerva
local ents_Create = SERVER and ents.Create

minerva.buildings = minerva.buildings or {}
minerva.buildings.stored = {}

function minerva.buildings.Get(buildingIndex)
    return minerva.buildings.stored[buildingIndex]
end

function minerva.buildings.GetAll()
    return minerva.buildings.stored
end

function minerva.buildings.Register(buildingData)
    if not ( buildingData.name ) then
        error("No name provided for building "..#buildingData.."!")
    end

    if not ( buildingData.model ) then
        error("No model provided for building "..buildingData.name.."!")
    end

    if not ( buildingData.uniqueID ) then
        error("No uniqueID provided for building "..buildingData.name.."!")
    end

    local buildingDataIndex = #minerva.buildings.stored + 1
    buildingData.index = buildingDataIndex

    minerva.buildings.stored[buildingData.uniqueID] = buildingData

    return buildingDataIndex
end

if ( SERVER ) then
    function minerva.buildings.Create(uniqueID, callback)
        local buildingTable = minerva.buildings.Get(uniqueID)

        local building = ents_Create("minervawars_building")
        building:Spawn()
        building:SetBuildingIndex(uniqueID)
        building:SetModel(buildingTable.model)
        building:PhysicsInit(SOLID_BBOX)
        building:SetSolid(SOLID_BBOX)

        if ( callback ) then
            callback(building)
        end
    end
end

minerva.util.IncludeDirectory("minervawars/gamemode/buildings", true)