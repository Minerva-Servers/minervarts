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
UNIT_BASE_COMBINE = minerva.units:Register({
    Class = "npc_combine_s",
    Name = "Combine Soldier Base",
    Description = "A template for Combine soldiers.",
    Category = "Combine Overwatch",
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
UNIT_COMBINE_SOLDIER_SMG = minerva.units:Register({
    Base = UNIT_BASE_COMBINE,
    Name = "Combine Soldier",
    Description = "A soldier of the Combine Overwatch.",
    Category = "Combine Overwatch",
    Health = 200,
    Weapons = {"weapon_smg1"},
    CanProduce = function(this, ply)
        return false
    end
})

UNIT_COMBINE_SOLDIER_SHOTGUN = minerva.units:Register({
    Base = UNIT_BASE_COMBINE,
    Name = "Combine Soldier Shotgunner",
    Description = "A soldier of the Combine Overwatch.",
    Category = "Combine Overwatch",
    Health = 250,
    Weapons = {"weapon_shotgun"},
    CustomInitialize = function(self)
        self:SetSkin(1)
    end,
    CanProduce = function(this, ply)
        return false
    end
})

UNIT_COMBINE_SOLDIER_AR2 = minerva.units:Register({
    Base = UNIT_BASE_COMBINE,
    Name = "Combine Soldier AR2",
    Description = "A soldier of the Combine Overwatch.",
    Category = "Combine Overwatch",
    Health = 200,
    Weapons = {"weapon_ar2"},
    CanProduce = function(this, ply)
        return false
    end
})

UNIT_COMBINE_ELITE = minerva.units:Register({
    Base = UNIT_BASE_COMBINE,
    Name = "Combine Elite",
    Description = "A high-ranking soldier of the Combine Overwatch.",
    Category = "Combine Overwatch",
    Models = {"models/combine_super_soldier/lw_combine_super_soldier.mdl"},
    Health = 300,
    Weapons = {"weapon_ar2"},
    CanProduce = function(this, ply)
        return false
    end
})