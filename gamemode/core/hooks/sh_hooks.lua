local zoomDistance = zoomDistance or 0
local zoomSpeed = 25
function GM:PlayerButtonDown(ply, key)
    if ( key == MOUSE_WHEEL_DOWN ) then
        zoomDistance = zoomDistance - zoomSpeed
    elseif ( key == MOUSE_WHEEL_UP ) then
        zoomDistance = zoomDistance + zoomSpeed
    end

    if ( zoomDistance < 0 ) then
        zoomDistance = 0
    elseif ( zoomDistance > 100 ) then
        zoomDistance = 100
    end
end

function GM:Move(ply, mv)
    local speed = 0.00005
    local ang = mv:GetMoveAngles()
    local pos = mv:GetOrigin()
    local vel = mv:GetVelocity()

    vel = vel + ang:Forward() * mv:GetForwardSpeed() * speed
    vel = vel + ang:Right() * mv:GetSideSpeed() * speed
    vel.z = 0 // Zero out the Z component of the velocity vector

    if ( math.abs( mv:GetForwardSpeed() ) + math.abs( mv:GetSideSpeed() ) < 0.1 ) then // Only check forward and side speed
        vel = vel * 0.90
    else
        vel = vel * 0.99
    end

    // Perform a trace to check if there's an obstacle between the current position and the desired position
    local trace = util.TraceLine({
        start = pos,
        endpos = pos + vel,
        mask = MASK_PLAYERSOLID_BRUSHONLY,
        filter = ply
    })

    // If there's an obstacle, adjust the desired position accordingly
    if trace.Hit then
        pos = trace.HitPos - vel:GetNormalized() * 5
    else
        pos = pos + vel
    end

    local trace2 = util.TraceLine({
        start = pos,
        endpos = pos + Vector(0, 0, -1000000),
        mask = MASK_PLAYERSOLID_BRUSHONLY,
    })

    pos.z = Lerp(0.06, pos.z, trace2.HitPos.z + 800 - zoomDistance * 5)

    if ( pos.z < -1000 ) then
        pos = Vector(0, 0, 100)
    end

    mv:SetVelocity(vel)
    mv:SetOrigin(pos)

    return true
end