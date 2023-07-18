local error = error
local team_SetUp = team.SetUp
local minerva = minerva

minerva.factions = minerva.factions or {}
minerva.factions.stored = {}

function minerva.factions.Get(factionIndex)
    return minerva.factions.stored[factionIndex]
end

function minerva.factions.GetAll()
    return minerva.factions.stored
end

function minerva.factions.Register(factionData)
    if not ( factionData.name ) then
        error("No name provided for faction "..#factionData.."!")
    end

    if not ( factionData.color ) then
        error("No color provided for faction "..factionData.name.."!")
    end

    local factionDataIndex = #minerva.factions.stored + 1
    factionData.index = factionDataIndex

    minerva.factions.stored[#minerva.factions.stored + 1] = factionData

    team_SetUp(factionDataIndex, factionData.name, factionData.color, false)

    return factionDataIndex
end

minerva.util.IncludeDirectory("minervawars/gamemode/factions", true)