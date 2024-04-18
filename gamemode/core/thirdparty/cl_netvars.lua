local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

minerva.netvar = minerva.netvar or {}
minerva.netvar.globals = minerva.netvar.globals or {}

net.Receive("MinervaGlobalVarSet", function()
	minerva.netvar.globals[net.ReadString()] = net.ReadType()
end)

net.Receive("MinervaNetVarSet", function()
	local index = net.ReadUInt(16)

	minerva.netvar[index] = minerva.netvar[index] or {}
	minerva.netvar[index][net.ReadString()] = net.ReadType()
end)

net.Receive("MinervaNetVarDelete", function()
	minerva.netvar[net.ReadUInt(16)] = nil
end)

net.Receive("MinervaLocalVarSet", function()
	local key = net.ReadString()
	local var = net.ReadType()

	minerva.netvar[LocalPlayer():EntIndex()] = minerva.netvar[LocalPlayer():EntIndex()] or {}
	minerva.netvar[LocalPlayer():EntIndex()][key] = var

	hook.Run("OnLocalVarSet", key, var)
end)

function GetNetVar(key, default) // luacheck: globals GetNetVar
	local value = minerva.netvar.globals[key]

	return value != nil and value or default
end

function entityMeta:GetNetVar(key, default)
	local index = self:EntIndex()

	if (minerva.netvar[index] and minerva.netvar[index][key] != nil) then
		return minerva.netvar[index][key]
	end

	return default
end

playerMeta.GetLocalVar = entityMeta.GetNetVar