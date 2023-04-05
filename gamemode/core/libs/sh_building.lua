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

    local buildingDataIndex = #minerva.buildings.stored + 1
    buildingData.index = buildingDataIndex

    minerva.buildings.stored[#minerva.buildings.stored + 1] = buildingData

    return buildingDataIndex
end

if ( SERVER ) then
    function minerva.buildings.Create(uniqueID, callback)
        local buildingIndex
    
        for index, building in ipairs(minerva.buildings.GetAll()) do
            if ( building.uniqueID == uniqueID ) then
                buildingIndex = index
                break
            end
        end
    
        if not ( buildingIndex ) then
            error("Building with uniqueID "..uniqueID.." does not exist!")
            return
        end

        local buildingTable = minerva.buildings.Get(buildingIndex)

        local building = ents.Create("minervawars_building")
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

minerva.util.IncludeDirectory("minervawars/gamemode/buildings", true)