gmodwars.units = gmodwars.units or {}
gmodwars.units.stored = {}

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

function gmodwars.units.Get(unitIndex)
    return gmodwars.units.stored[unitIndex]
end

function gmodwars.units.GetAll()
    return gmodwars.units.stored
end

function gmodwars.units.Register(unitData)
    if not ( unitData.name ) then
        error("No name provided for unit "..#unitData.."!")
    end

    if not ( unitData.models ) then
        error("No models provided for unit "..unitData.name.."!")
    end

    local unitDataIndex = #gmodwars.units.stored + 1
    unitData.index = unitDataIndex

    gmodwars.units.stored[#gmodwars.units.stored + 1] = unitData

    return unitDataIndex
end

if ( SERVER ) then
    function gmodwars.units.Create(unitIndex, callback)
        local unitTable = gmodwars.units.Get(unitIndex)

        local unit = ents.Create("gmodwars_unit")
        unit:SetUnitIndex(unitIndex)
        unit:Spawn()
        unit:SetModel(table.Random(unitTable.models or CITIZEN_MODELS))

        if ( callback ) then
            callback(unit)
        end
    end
end

gmodwars.util.IncludeDirectory("gmodwars/gamemode/units", true)