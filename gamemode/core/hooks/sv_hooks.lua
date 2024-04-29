// Server-side hooks

local loadQueue = {}
function GM:PlayerInitialSpawn(ply)
    ply:SetNoDraw(true)
    ply:SetNotSolid(true)
    ply:Lock()
    ply:SetTeam(TEAM_UNASSIGNED)

    timer.Simple(1, function()
        if not ( IsValid(ply) ) then
            return
        end

        ply:KillSilent()
    end)

    loadQueue[ply] = true
end

function GM:StartCommand(ply, cmd)
    if ( loadQueue[ply] and not cmd:IsForced() ) then
        loadQueue[ply] = nil
        
        hook.Run("PostPlayerInitialSpawn", ply)
    end
end

function GM:PostPlayerInitialSpawn(ply)
    net.Start("MinervaSetup")
    net.Send(ply)
end

function GM:PlayerSpawn(ply)
    ply:SetNoDraw(false)
    ply:UnLock()
    ply:SetNotSolid(false)
    ply:SetMoveType(MOVETYPE_NOCLIP)
    ply:SetDSP(1)

    hook.Run("PlayerLoadout", ply)
end

function GM:PlayerLoadout(ply)
    ply:StripWeapons()
    ply:StripAmmo()

    ply:SetWalkSpeed(125)
    ply:SetRunSpeed(225)
    ply:SetJumpPower(200)
    ply:SetupHands()

    hook.Run("PostPlayerLoadout", ply)
end

function GM:PostPlayerLoadout(ply)
    ply:Give("gmod_camera")
    ply:Give("minerva_rts_selector")
    ply:SelectWeapon("minerva_rts_selector")

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

function GM:PreGamemodeChanged(oldGM, newGM)
end

function GM:PostGamemodeChanged(oldGM, newGM)
end

function GM:PlayerDeathThink(ply)
    return false
end