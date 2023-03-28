local UNIT = {}

UNIT.name = "Rebel"
UNIT.description = ""

UNIT.population = 1
UNIT.buildTime = 24
UNIT.health = 150
UNIT.speed = 224
UNIT.viewDistance = 768
UNIT.canTakeCover = true

UNIT.models = {
    "models/humans/group03/male_01.mdl",
    "models/humans/group03/male_02.mdl",
    "models/humans/group03/male_04.mdl",
    "models/humans/group03/male_05.mdl",
    "models/humans/group03/male_06.mdl",
    "models/humans/group03/male_07.mdl",
    "models/humans/group03/male_08.mdl",
    "models/humans/group03/male_09.mdl",
    "models/humans/group03/female_01.mdl",
    "models/humans/group03/female_02.mdl",
    "models/humans/group03/female_03.mdl",
    "models/humans/group03/female_06.mdl",
    "models/humans/group03/female_07.mdl",
    "models/humans/group03/female_04.mdl"
}

UNIT.costs = {
    [RESOURCE_REQUISITION] = 20,
}

UNIT.abilities = {
    [ABILITY_ATTACK] = true,
    [ABILITY_HOLD] = true,
    [ABILITY_PATROL] = true,
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

UNIT_REBEL = gmodwars.units.Register(UNIT)