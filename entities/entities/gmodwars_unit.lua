AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "UnitIndex")
end

if ( SERVER ) then

function ENT:Initialize()
	self:SetUnitIndex(0)
	self:SetModel("models/kleiner.mdl")
end

end