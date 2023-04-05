local BUILDING = {}

BUILDING.uniqueID = "building_reb_headquarters"
BUILDING.name = "Rebel Headquarters"
BUILDING.description = ""

BUILDING.providesPopulation = 7
BUILDING.buildTime = 100
BUILDING.health = 2000

BUILDING.model = "models/lw_props/lw_buildings/lw_rebel_hq.mdl"

BUILDING.costs = {
    ["resource_requisition"] = 300,
}

BUILDING.abilities = {
    ["unit_citizen"] = true,
}

BUILDING.idleSequence = "idle"
BUILDING.constructSequence = "deployed"
BUILDING.workSequence = "work"

BUILDING_REBEL_HQ = minerva.buildings.Register(BUILDING)