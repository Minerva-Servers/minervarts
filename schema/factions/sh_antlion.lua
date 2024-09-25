FACTION_ANTLIONs = minerva.factions:Register({
    Name = "Antlions",
    Description = "The Antlions are a species of insect-like creatures native to the barren wastelands of Xen. They are known for their ferocity and their ability to burrow through the ground.",
    Color = minerva.util:VectorToColor(Vector(0.9, 0.8, 0.3)),
    StartBuildings = {
        "building_antlion_hive",
    },
    StartUnits = {
        "unit_antlion_worker",
    },
    StartResources = {
        Requisition = 100,
    },
})