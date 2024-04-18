function GM:PlayerLoadout(ply)
    timer.Simple(1 / 3, function()
        hook.Run("PostPlayerLoadout", ply)
    end)

    return true
end

function GM:PostPlayerLoadout(ply)
    ply:SetupHands()
    ply:StripWeapons()
    ply:Give("gmod_camera")
    ply:Give("minerva_rts_selector")
    ply:SelectWeapon("minerva_rts_selector")
    ply:SetMoveType(MOVETYPE_NOCLIP)
    ply:SetNoDraw(true)
    ply:SetNotSolid(true)

    if ( ply:IsAdmin() ) then
        ply:Give("weapon_physgun")
        ply:Give("gmod_tool")
    end

    ply:SetNetVar("selected", {})
end

function GM:PlayerNoClip(ply)
    return false
end

function GM:PlayerUse(ply)
    local trace = ply:GetEyeTrace()
    local ent = trace.Entity

    if ( IsValid(ent) ) then
        return false
    end

    local selected = ply:GetNetVar("selected", {})

    return false
end