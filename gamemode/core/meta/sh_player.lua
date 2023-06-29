local META = FindMetaTable("Player")

function META:IsStuck()
    return util.TraceEntity({
        start = self:GetPos(),
        endpos = self:GetPos(),
        filter = self
    }, self).StartSolid
end