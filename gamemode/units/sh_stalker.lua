local UNIT = {}

UNIT.uniqueID = "unit_stalker"
UNIT.name = "Stalker"
UNIT.description = "Mindless servants of the Combine, surgically altered both physically and mentally to operate machinery and guard the Citadel core."
UNIT.icon = "minervawars/abilities/unit_stalker.png"

UNIT.population = 1
UNIT.buildTime = 12
UNIT.health = 150
UNIT.speed = 96
UNIT.viewDistance = 869
UNIT.canTakeCover = false

UNIT.models = {
    "models/stalker.mdl",
}

UNIT.costs = {
    ["resource_requisition"] = 15,
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

UNIT_STALKER = minerva.units.Register(UNIT)