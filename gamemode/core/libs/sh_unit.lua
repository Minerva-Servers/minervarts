minerva.units = minerva.units or {}
minerva.units.stored = {}

local CITIZEN_MODELS = {
    "models/humans/group01/male_01.mdl",
    "models/humans/group01/male_02.mdl",
    "models/humans/group01/male_04.mdl",
    "models/humans/group01/male_05.mdl",
    "models/humans/group01/male_06.mdl",
    "models/humans/group01/male_07.mdl",
    "models/humans/group01/male_08.mdl",
    "models/humans/group01/male_09.mdl",
    "models/humans/group02/male_01.mdl",
    "models/humans/group02/male_03.mdl",
    "models/humans/group02/male_05.mdl",
    "models/humans/group02/male_07.mdl",
    "models/humans/group02/male_09.mdl",
    "models/humans/group01/female_01.mdl",
    "models/humans/group01/female_02.mdl",
    "models/humans/group01/female_03.mdl",
    "models/humans/group01/female_06.mdl",
    "models/humans/group01/female_07.mdl",
    "models/humans/group02/female_01.mdl",
    "models/humans/group02/female_03.mdl",
    "models/humans/group02/female_06.mdl",
    "models/humans/group01/female_04.mdl"
}

function minerva.units.Get(unitIndex)
    return minerva.units.stored[unitIndex]
end

function minerva.units.GetAll()
    return minerva.units.stored
end

function minerva.units.Register(unitData)
    if not ( unitData.name ) then
        error("No name provided for unit "..#unitData.."!")
    end

    if not ( unitData.models ) then
        error("No models provided for unit "..unitData.name.."!")
    end

    local unitDataIndex = #minerva.units.stored + 1
    unitData.index = unitDataIndex

    minerva.units.stored[#minerva.units.stored + 1] = unitData

    return unitDataIndex
end

if ( SERVER ) then
    function minerva.units.Create(unitIndex, callback)
        local unitTable = minerva.units.Get(unitIndex)

        local unit = ents.Create("minervawars_unit")
        unit:SetUnitIndex(unitIndex)
        unit:Spawn()
        unit:SetModel(table.Random(unitTable.models or CITIZEN_MODELS))

        if ( callback ) then
            callback(unit)
        end
    end
end

minerva.util.IncludeDirectory("minervawars/gamemode/units", true)