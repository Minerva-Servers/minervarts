local UNIT = {}

UNIT.uniqueID = "unit_citizen"
UNIT.name = "Citizen"
UNIT.description = "Citizens are ordinary humans who are not directly involved with either the Combine or the Resistance."

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
    ["resource_requisition"] = 5,
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

UNIT_CITIZEN = minerva.units.Register(UNIT)