local minerva = minerva

// REBEL
local BUILDING = {}

BUILDING.uniqueID = "building_reb_headquarters"
BUILDING.name = "Rebel Headquarters"
BUILDING.description = "The Rebel headquarters is a large, red barn-like structure tucked away in a secluded part of the countryside. The building stands out against the natural surroundings, but is hidden from the prying eyes of the Combine thanks to a network of underground tunnels and secret entrances. The interior is bustling with activity, with makeshift living quarters, storerooms, and workshops crammed into every available space. The atmosphere is one of camaraderie and hope, with people from all walks of life coming together to fight against the Combine's oppressive regime. The Rebel HQ is a symbol of resistance, a place where the downtrodden can gather and feel safe in their shared struggle for freedom."

BUILDING.providesPopulation = 7
BUILDING.buildTime = 100
BUILDING.health = 2000

BUILDING.model = "models/lw_props/lw_buildings/lw_rebel_hq.mdl"

BUILDING.costs = {
    ["resource_requisition"] = 300,
}

BUILDING.abilities = {
    ["unit_rebel_engineer"] = true,
}

BUILDING.idleSequence = "idle"
BUILDING.constructSequence = "deployed"
BUILDING.workSequence = "work"

BUILDING_REBEL_HQ = minerva.buildings.Register(BUILDING)

// COMBINE
BUILDING = {}

BUILDING.uniqueID = "building_comb_headquarters"
BUILDING.name = "Combine Headquarters"
BUILDING.description = "The Combine headquarters is a towering structure that closely resembles a smaller version of the citadel. It features dark, imposing architecture with sharp angles and a towering central spire. The building is surrounded by walls and guard towers, with heavily armed soldiers stationed at every entrance. The interior is a labyrinthine network of hallways, labs, and holding cells, with a looming sense of oppression and fear pervading every inch of the space. Screens and speakers are scattered throughout, constantly broadcasting propaganda and surveillance footage. The Combine HQ is the nerve center of their oppressive regime, where they plot and scheme to maintain their hold on power."
BUILDING.icon = "minervawars/abilities/building_comb_headquarters.png"

BUILDING.providesPopulation = 9
BUILDING.buildTime = 100
BUILDING.health = 2000

BUILDING.model = "models/lw_props/lw_buildings/combine/lw_combine_hq.mdl"

BUILDING.costs = {
    ["resource_requisition"] = 300,
}

BUILDING.abilities = {
    ["unit_stalker"] = true,
}

BUILDING.idleSequence = "idle"
BUILDING.constructSequence = "deployed"
BUILDING.workSequence = "work"

BUILDING_COMB_HQ = minerva.buildings.Register(BUILDING)