FACTION_REBELS = minerva.factions:Register({
    Name = "Rebels",
    Description = "The Resistance is a powerful covert organization of humans and Vortigaunts with the shared goal of defeating the Combine and restoring their freedom.",
    Color = minerva:VectorToColor(Vector(0.9, 0.6, 0.1)),
    StartBuildings = {
        "building_rebels_hq",
    },
    StartUnits = {
        "unit_rebel_engineer",
    },
    StartResources = {
        Requisition = 100,
    },
})