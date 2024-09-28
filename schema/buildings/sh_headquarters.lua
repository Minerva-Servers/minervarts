// Base
BUILDING_HQ_BASE = minerva.buildings:Register({
    Name = "Headquarters Base",
    Description = "The base for all headquarter buildings.",
    Category = "Headquarters",
    Model = "models/lw_props/lw_buildings/lw_rebel_hq.mdl",
    Health = 2000,

    // Sequences
    IdleSequence = "idle",
    ConstructSequence = "deployed",
    WorkSequence = "work",

    BuildTime = 100,
    ProvidesPopulation = 7,
})

// Combine Headquarters
BUILDING_HQ_COMBINE = minerva.buildings:Register({
    Base = BUILDING_HQ_BASE,
    Name = "Combine Headquarters",
    Description = "The Combine headquarters building.",
    Model = "models/lw_props/lw_buildings/combine/lw_combine_hq.mdl",

    ProvidesPopulation = 9,
})

// Rebel Headquarters
BUILDING_HQ_REBEL = minerva.buildings:Register({
    Base = BUILDING_HQ_BASE,
    Name = "Rebel Headquarters",
    Description = "The Rebel headquarters building.",
    Model = "models/lw_props/lw_buildings/lw_rebel_hq.mdl",

    ProvidesPopulation = 7,
})