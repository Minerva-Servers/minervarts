// Server-side hooks

local loadQueue = {}
function GM:PlayerInitialSpawn(ply)
    ply:SetNoDraw(true)
    ply:SetNotSolid(true)
    ply:Lock()
    ply:SetTeam(TEAM_UNASSIGNED)

    timer.Simple(1, function()
        if ( !IsValid(ply) ) then return end

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
    local lobbyOwner = nil
    if ( #player.GetHumans() == 1 ) then
        lobbyOwner = ply
    end

    SetNetVar("lobbyOwner", ply)

    net.Start("MinervaSetup")
    net.Send(ply)

    timer.Simple(0.1, function()
        net.Start("MinervaSetup.PopulatePlayers")
        net.Broadcast()
    end)
end

function GM:PlayerDisconnected(ply)
    local lobbyOwner = GetNetVar("lobbyOwner", NULL)
    if ( lobbyOwner == ply ) then
        SetNetVar("lobbyOwner", NULL)

        local players = {}
        for k, v in ipairs(player.GetHumans()) do
            if ( v == ply ) then continue end

            table.insert(players, v)
        end

        if ( #players > 0 ) then
            SetNetVar("lobbyOwner", players[math.random(1, #players)])
        end
    end

    timer.Simple(0.1, function()
        net.Start("MinervaSetup.PopulatePlayers")
        net.Broadcast()
    end)
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

function GM:PlayerSay(ply, text, teamChat)
    if ( string.sub(text, 1, 1) == "/" ) then
        local arguments = string.Explode(" ", string.sub(text, 2))
        local command = arguments[1]
        table.remove(arguments, 1)

        minerva.commands:Run(ply, command, arguments)

        return ""
    end
end

function GM:UpdateRelationship(ent1, ent2, relationship)
    if ( !IsValid(ent1) or !IsValid(ent2) ) then return end

    ent1:AddEntityRelationship(ent2, relationship, 99)
    ent2:AddEntityRelationship(ent1, relationship, 99)
end

function GM:UpdateRelationships(ent)
    if ( !IsValid(ent) ) then
        for k, v in ents.Iterator() do
            if ( !v:IsNPC() ) then continue end

            hook.Run("UpdateRelationships", v)
        end

        return
    end

    if ( !ent:IsNPC() ) then return end

    for k, v in ents.Iterator() do
        if ( v == ent ) then continue end
        if ( !v:IsNPC() ) then continue end

        local disposition = D_HT
        if ( ent:GetNetVar("team", 0) == v:GetNetVar("team", 0) ) then
            disposition = D_LI
        elseif ( ent:GetNetVar("team", 0) == 0 or v:GetNetVar("team", 0) == 0 ) then
            disposition = D_NU
        elseif ( ent:GetNetVar("team", 0) == -1 or v:GetNetVar("team", 0) == -1 ) then
            disposition = D_HT
        end

        hook.Run("UpdateRelationship", ent, v, disposition)
    end
end

function GM:PlayerSpawnedNPC(ply, ent)
    ent:SetNetVar("owner", ply:SteamID64())
    ent:SetNetVar("team", ply:Team())
    ent:SetNetVar("faction", ply:GetFaction())

    if ( ent.SetSquad ) then
        ent:SetSquad()
    end

    if ( ent.SetCurrentWeaponProficiency ) then
        ent:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
    end

    timer.Simple(0.1, function()
        --hook.Run("UpdateRelationships")
    end)
end

concommand.Add("minerva_set_team", function(ply, cmd, args)
    if ( !IsValid(ply) ) then return end

    local ent = ply:GetEyeTrace().Entity
    if ( !IsValid(ent) or !ent:IsNPC() ) then return end

    ent:SetNetVar("team", tonumber(args[1]) or 0)
    ent:SetSquad()

    hook.Run("UpdateRelationships", ent)
end)

concommand.Add("minerva_set_faction", function(ply, cmd, args)
    if ( !IsValid(ply) ) then return end

    local ent = ply:GetEyeTrace().Entity
    if ( !IsValid(ent) or !ent:IsNPC() ) then return end

    ent:SetNetVar("faction", tonumber(args[1]) or 0)
    ent:SetSquad()
end)