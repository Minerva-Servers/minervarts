// Base
UNIT_BASE_CITIZEN = minerva.units:Register({
    Class = "npc_citizen",
    Name = "Citizen Base",
    Description = "The base citizen unit.",
    Category = "Citizens",
    Models = {
        "models/humans/group01/female_01.mdl",
        "models/humans/group01/female_02.mdl",
        "models/humans/group01/female_03.mdl",
        "models/humans/group01/female_04.mdl",
        "models/humans/group01/female_06.mdl",
        "models/humans/group01/female_07.mdl",
        "models/humans/group01/male_01.mdl",
        "models/humans/group01/male_02.mdl",
        "models/humans/group01/male_03.mdl",
        "models/humans/group01/male_04.mdl",
        "models/humans/group01/male_05.mdl",
        "models/humans/group01/male_06.mdl",
        "models/humans/group01/male_07.mdl",
        "models/humans/group01/male_08.mdl",
        "models/humans/group01/male_09.mdl",
    },
    Health = 50,
})

// Units
UNIT_CITIZEN_SMG = minerva.units:Register({
    Base = UNIT_BASE_CITIZEN,
    Name = "Refugee",
    Description = "A refugee from City 17.",
    Category = "Citizens",
    Health = 50,
    Weapons = {"weapon_smg1"},
    CustomInitialize = function(self)
        local model = self:GetModel()
        model = string.gsub(model, "group01", "group02")
        self:SetModel(model)
    end,
    CanProduce = function(this, ply)
        return false
    end
})