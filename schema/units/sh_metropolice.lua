// Sounds
sound.Add({
    name = "MinervaMetrocop.Pain",
    channel = CHAN_AUTO,
    volume = 0.7,
    level = 80,
    pitch = {90, 110},
    sound = {
        "npc/metropolice/pain1.wav",
        "npc/metropolice/pain2.wav",
        "npc/metropolice/pain3.wav",
        "npc/metropolice/pain4.wav",
    },
})

sound.Add({
    name = "MinervaMetrocop.Die",
    channel = CHAN_AUTO,
    volume = 0.7,
    level = 80,
    pitch = {90, 110},
    sound = {
        "npc/metropolice/die1.wav",
        "npc/metropolice/die2.wav",
        "npc/metropolice/die3.wav",
        "npc/metropolice/die4.wav",
    },
})

// Base
UNIT_BASE_METROPOLICE = minerva.units:Register({
    Class = "npc_metropolice",
    Name = "Metrocop Base",
    Description = "A template for Metrocops.",
    Category = "Combine Overwatch",
    Models = {"models/police/lw_police.mdl"},
    Health = 100,

    CanPatrol = false, // Use base patrol behaviour

    AlertSounds = "ZBaseMetrocop.Alert", // Sounds emitted when an enemy is seen for the first time
    KilledEnemySounds = "ZBaseMetrocop.KillEnemy", // Sounds emitted when the NPC kills an enemy

    LostEnemySounds = "ZBaseMetrocop.LostEnemy", // Sounds emitted when the enemy is lost
    OnReloadSounds = "ZBaseMetrocop.Reload", // Sounds emitted when the NPC reloads
    OnGrenadeSounds = "ZBaseMetrocop.Grenade", // Sounds emitted when the NPC throws a grenade

    HearDangerSounds = "ZBaseMetrocop.HearSound",

    FootStepSounds = "ZBaseMetrocop.Step", // Footstep sound

    FollowPlayerSounds = "ZBaseMetrocop.Answer", // Sounds emitted when the NPC starts following a player
    UnfollowPlayerSounds = "ZBaseMetrocop.Answer", // Sounds emitted when the NPC stops following a player

    PainSounds = "MinervaMetrocop.Pain", // Sounds emitted when the NPC is hurt
    DeathSounds = "MinervaMetrocop.Die", // Sounds emitted when the NPC dies
})

// Units
UNIT_METROPOLICE = minerva.units:Register({
    Base = UNIT_BASE_METROPOLICE,
    Name = "Metrocop",
    Description = "The Metrocop is a standard unit of the Combien Overwatch Civil Protection.",
    Category = "Combine Overwatch",
    Weapons = {"weapon_pistol"},
    CanProduce = function(this, ply)
        return false
    end
})