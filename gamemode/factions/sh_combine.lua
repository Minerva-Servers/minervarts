local FACTION = {}

FACTION.uniqueID = "faction_combine"
FACTION.name = "Combine"
FACTION.description = ""
FACTION.color = Color(26, 153, 230)

FACTION.hudName = "hud_combine"
FACTION.startBuilding = "building_comb_headquarters"
FACTION.startUnit = "unit_stalker"

FACTION.resourceTypes = {
    ["resource_requisition"] = true,
    ["resource_power"] = true,
}

FACTION_COMBINE = minerva.factions.Register(FACTION)