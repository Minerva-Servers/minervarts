local util_TraceHull = util.TraceHull
local Vector = Vector
local Lerp = Lerp

local zoomDistance = zoomDistance or 0
local zoomSpeed = zoomSpeed or 25
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

    ang.p = 0

    vel = vel + ang:Forward() * mv:GetForwardSpeed() * speed
    vel = vel + ang:Right() * mv:GetSideSpeed() * speed
    vel.z = 0 // Zero out the Z component of the velocity vector

    vel = vel * 0.99

    // Perform a trace to check if there's an obstacle between the current position and the desired position
    local trace = util_TraceHull({
        start = pos,
        endpos = pos + vel,
        mins = Vector(-64, -64, -64),
        maxs = Vector(64, 64, 64),
        mask = MASK_PLAYERSOLID_BRUSHONLY,
        filter = ply,
    })

    // If there's an obstacle, adjust the desired position accordingly
    if ( trace.Hit ) then
        pos = trace.HitPos - vel:GetNormalized() * 5
    else
        pos = pos + vel
    end

    local trace2 = util_TraceHull({
        start = pos,
        endpos = pos + Vector(0, 0, -1000000),
        mins = Vector(-64, -64, -64),
        maxs = Vector(64, 64, 64),
        mask = MASK_PLAYERSOLID_BRUSHONLY,
        filter = ply,
    })

    pos.z = Lerp(0.06, pos.z, trace2.HitPos.z + 800)

    if ( ply:IsStuck() ) then
        pos = Vector(0, 0, 100)
    end

    mv:SetVelocity(vel)
    mv:SetOrigin(pos)

    return true
end