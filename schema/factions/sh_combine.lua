FACTION_COMBINE = minerva.factions:Register({
    Name = "Combine",
    Description = "The Combine, referred to as \"Our Benefactors\" and CMB in propaganda, is the title of an immense and powerful inter-dimensional empire, composed of a variety of both allied and enslaved species",
    Color = minerva.util:VectorToColor(Vector(0.1, 0.6, 0.9)),
    StartBuildings = {
        "building_combine_hq",
    },
    StartUnits = {
        "unit_stalker",
    },
    StartResources = {
        Requisition = 100,
    },
})