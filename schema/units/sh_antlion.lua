// Base
UNIT_BASE_ANTLION = minerva.units:Register({
    Class = "npc_antlion",
    Name = "Antlion Base",
    Description = "The base antlion unit.",
    Category = "Antlions",
    Models = {
        "models/antlion.mdl",
    },
    Health = 30,

    BloodColor = BLOOD_COLOR_ANTLION,
    FootStepSounds = "NPC_Antlion.Footstep",
    GibMaterial = false,
    GibParticle = "AntlionGib",
    MuteDefaultVoice = false,
    RagdollUseAltPositioning = true,

    OnInitCap = function(this)
        this:CapabilitiesRemove(CAP_INNATE_RANGE_ATTACK1)
    end,

    ShouldGib = function(this, dmgInfo, hitGroup)
        if ( dmgInfo:GetDamage() < 40 ) then return end

        local gibs = {
            this:CreateGib("models/gibs/antlion_gib_large_1.mdl", {offset = Vector(0, 0, 0)}),
            this:CreateGib("models/gibs/antlion_gib_large_2.mdl", {offset = Vector(0, 0, 0)}),
            this:CreateGib("models/gibs/antlion_gib_large_3.mdl", {offset = Vector(0, 0, 0)}),
            this:CreateGib("models/gibs/antlion_gib_medium_1.mdl", {offset = Vector(0, 0, 0)}),
            this:CreateGib("models/gibs/antlion_gib_medium_2.mdl", {offset = Vector(0, 0, 0)}),
            this:CreateGib("models/gibs/antlion_gib_small_1.mdl", {offset = Vector(0, 0, 0)}),
            this:CreateGib("models/gibs/antlion_gib_small_2.mdl", {offset = Vector(0, 0, 0)}),
        }

        if ( this.GibMaterial ) then
            for _, v in ipairs(gibs) do
                v:SetMaterial(this.GibMaterial)
            end
        end

        ParticleEffect(this.GibParticle, this:WorldSpaceCenter(), this:GetAngles())

        this:EmitSound("NPC_Antlion.RunOverByVehicle")

        return true
    end
})

// Units
UNIT_ANTLION = minerva.units:Register({
    Base = UNIT_BASE_ANTLION,
    Name = "Antlion",
    Description = "An antlion unit.",
    Category = "Antlions",
    Health = 30,
    Weapons = {},
    CanProduce = function(this, ply)
        return false
    end
})