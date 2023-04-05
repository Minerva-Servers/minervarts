local UNIT = {}

UNIT.uniqueID = "unit_rebel_engineer"
UNIT.name = "Rebel Engineer"
UNIT.description = "Skilled builders and repairers who gather scrap from designated points to construct and maintain structures for the Resistance."

UNIT.population = 1
UNIT.buildTime = 15
UNIT.health = 50
UNIT.speed = 180
UNIT.viewDistance = 768
UNIT.canTakeCover = true

UNIT.models = {
    "models/humans/group03/male_06.mdl",
}

UNIT.costs = {
    ["resource_requisition"] = 20,
}

UNIT.abilities = {
    ["ability_attack"] = true,
    ["ability_hold"] = true,
    ["ability_patrol"] = true,
}

UNIT.sounds = {
    select = {
        "",
    },
    move = {
        "",
    },
    attack = {
        "",
    },
    death = {
        "",
    },
}

UNIT_REBEL_ENGINEER = minerva.units.Register(UNIT)