function GM:Move(ply, mv)
	local speed = 0.00005
	local ang = mv:GetMoveAngles()
	local pos = mv:GetOrigin()
	local vel = mv:GetVelocity()

	vel = vel + ang:Forward() * mv:GetForwardSpeed() * speed
	vel = vel + ang:Right() * mv:GetSideSpeed() * speed

	if ( math.abs( mv:GetForwardSpeed() ) + math.abs( mv:GetSideSpeed() ) + math.abs( mv:GetUpSpeed() ) < 0.1 ) then
		vel = vel * 0.90
	else
		vel = vel * 0.99
	end

	pos = pos + vel

    local trace = util.TraceLine({
        start = ply:GetPos(),
        mask = MASK_SOLID_BRUSHONLY,
        endpos = Vector(0, 0, -1000000),
    })
    pos.z = Lerp(0.06, pos.z, trace.HitPos.z + 500)

    if ( pos.z < -1000 ) then
        pos = Vector(0, 0, 0)
    end

	mv:SetVelocity(vel)
	mv:SetOrigin(pos)

	return true
end