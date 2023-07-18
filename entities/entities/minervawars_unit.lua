local AddCSLuaFile = AddCSLuaFile
local Color = Color
local minerva = minerva

AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "UnitIndex")
end

function ENT:SetSelected(selected)
    self.selected = selected

    if ( self.selected ) then
        self:SetColor(Color(255, 255, 0))
    else
        self:SetColor(Color(255, 255, 255))
    end
end

function ENT:GetAbilities()
	if not ( minerva.units.Get(self:GetUnitIndex()) ) then
		return {}
	end

	return minerva.units.Get(self:GetUnitIndex()).abilities
end

if ( SERVER ) then
	function ENT:Initialize()
		self:SetUnitIndex("")
		self:SetModel("models/kleiner.mdl")
	end
end