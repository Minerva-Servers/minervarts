local Color = Color
local minerva = minerva

local FACTION = {}

FACTION.uniqueID = "faction_rebels"
FACTION.name = "Rebels"
FACTION.description = ""
FACTION.color = Color(229, 153, 25)

FACTION.hudName = "hud_rebels"
FACTION.startBuilding = "building_reb_headquarters"
FACTION.startUnit = "unit_rebel"

FACTION.resourceTypes = {
    ["resource_requisition"] = true,
    ["resource_scrap"] = true,
    ["resource_power"] = true,
}

FACTION_REBELS = minerva.factions.Register(FACTION)