local BUILDING = {}

BUILDING.name = "Rebel Headquarters"
BUILDING.description = ""

BUILDING.providesPopulation = 7
BUILDING.buildTime = 100
BUILDING.health = 2000

BUILDING.model = "models/lw_props/lw_buildings/lw_rebel_hq.mdl"

BUILDING.costs = {
    [RESOURCE_REQUISITION] = 300,
}

BUILDING.abilities = {
    [UNIT_CITIZEN] = true,
}

BUILDING.idleSequence = "idle"
BUILDING.constructSequence = "deployed"
BUILDING.workSequence = "work"

BUILDING_REBEL_HQ = gmodwars.buildings.Register(BUILDING)