local UNIT = {}

UNIT.name = "Citizen"
UNIT.description = ""

UNIT.population = 1
UNIT.buildTime = 8
UNIT.health = 50
UNIT.speed = 209
UNIT.viewDistance = 800
UNIT.canTakeCover = false

UNIT.models = {
    "models/humans/group01/male_01.mdl",
    "models/humans/group01/male_02.mdl",
    "models/humans/group01/male_04.mdl",
    "models/humans/group01/male_05.mdl",
    "models/humans/group01/male_06.mdl",
    "models/humans/group01/male_07.mdl",
    "models/humans/group01/male_08.mdl",
    "models/humans/group01/male_09.mdl",
    "models/humans/group01/female_01.mdl",
    "models/humans/group01/female_02.mdl",
    "models/humans/group01/female_03.mdl",
    "models/humans/group01/female_06.mdl",
    "models/humans/group01/female_07.mdl",
    "models/humans/group01/female_04.mdl"
}

UNIT.costs = {
    [RESOURCE_REQUISITION] = 5,
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

UNIT_CITIZEN = gmodwars.units.Register(UNIT)