local FindMetaTable = FindMetaTable
local util_TraceEntity = util.TraceEntity

local META = FindMetaTable("Player")

function META:IsStuck()
    return util_TraceEntity({
        start = self:GetPos(),
        endpos = self:GetPos(),
        filter = self
    }, self).StartSolid
end