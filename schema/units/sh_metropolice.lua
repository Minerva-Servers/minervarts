// Sounds
sound.Add({
    name = "MinervaCombine.Pain",
    channel = CHAN_AUTO,
    volume = 0.7,
    level = 80,
    pitch = {90, 110},
    sound = {
        "npc/combine_soldier/pain1.wav",
        "npc/combine_soldier/pain2.wav",
        "npc/combine_soldier/pain3.wav",
    },
})

sound.Add({
    name = "MinervaCombine.Die",
    channel = CHAN_AUTO,
    volume = 0.7,
    level = 80,
    pitch = {90, 110},
    sound = {
        "npc/combine_soldier/die1.wav",
        "npc/combine_soldier/die2.wav",
        "npc/combine_soldier/die3.wav",
    },
})

// Base
UNIT_BASE_METROPOLICE = minerva.units:Register({
    Class = "npc_metropolice",
    Name = "Combine Soldier Base",
    Description = "A template for Combine soldiers.",
    Category = "Combine",
    Models = {"models/combine_soldier/lw_combine_soldier.mdl"},
    Health = 200,

    m_nKickDamage = 15,
    
    BaseMeleeAttack = true, // Use ZBase melee attack system
    MeleeAttackAnimations = {ACT_MELEE_ATTACK1}, // Example: NPC.MeleeAttackAnimations = {ACT_MELEE_ATTACK1}
    MeleeAttackAnimationSpeed = 1, // Speed multiplier for the melee attack animation

    CanPatrol = false, // Use base patrol behaviour

    AlertSounds = "ZBaseCombine.Alert", // Sounds emitted when an enemy is seen for the first time
    KilledEnemySounds = "ZBaseCombine.KillEnemy", // Sounds emitted when the NPC kills an enemy

    LostEnemySounds = "ZBaseCombine.LostEnemy", // Sounds emitted when the enemy is lost
    OnReloadSounds = "ZBaseCombine.Reload", // Sounds emitted when the NPC reloads
    OnGrenadeSounds = "ZBaseCombine.Grenade", // Sounds emitted when the NPC throws a grenade

    HearDangerSounds = "ZBaseCombine.HearSound",

    FootStepSounds = "ZBaseCombine.Step", // Footstep sound

    FollowPlayerSounds = "ZBaseCombine.Answer", // Sounds emitted when the NPC starts following a player
    UnfollowPlayerSounds = "ZBaseCombine.Answer", // Sounds emitted when the NPC stops following a player

    PainSounds = "MinervaCombine.Pain", // Sounds emitted when the NPC is hurt
    DeathSounds = "MinervaCombine.Die", // Sounds emitted when the NPC dies
})

// Units
UNIT_METROPOLICE = minerva.units:Register({
    Base = UNIT_BASE_METROPOLICE,
    Name = "Metrocop",
    Description = "A soldier of the Combine Overwatch.",
    Category = "Combine",
    Health = 200,
    Weapons = {"weapon_smg1"},
    CanProduce = function(this, ply)
        return false
    end
})