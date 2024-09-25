// Server-side networking

util.AddNetworkString("MinervaChatText")
util.AddNetworkString("MinervaSetup")
util.AddNetworkString("MinervaSetup.PopulatePlayers")
util.AddNetworkString("MinervaSetup.KickPlayer")
util.AddNetworkString("MinervaSetup.JoinTeam")
util.AddNetworkString("MinervaSetup.ChangeFaction")
util.AddNetworkString("MinervaSetup.UnassignPlayer")

net.Receive("MinervaSetup.KickPlayer", function(length, ply)
    if ( !ply:IsAdmin() ) then return end

    local target = net.ReadUInt(32)
    local reason = net.ReadString()
    if ( !reason or reason == "" ) then
        reason = "No reason provided"
    end

    local name = "unknown player"
    local targetPlayer = minerva.util:FindPlayer(target)
    if ( IsValid(targetPlayer) ) then
        targetPlayer:Kick(reason)
        name = targetPlayer:Name()
    else
        minerva.util:PrintError("Player not found.", ply)
    end

    timer.Simple(0.1, function()
        net.Start("MinervaSetup.KickPlayer")
            net.WriteUInt(ply:UserID(), 32)
            net.WriteString(name)
            net.WriteString(reason)
        net.Broadcast()
    end)
end)

net.Receive("MinervaSetup.JoinTeam", function(length, ply)
    local teamID = net.ReadUInt(16)

    if ( ply:Team() == teamID ) then return end

    ply:SetTeam(teamID)

    timer.Simple(0.1, function()
        net.Start("MinervaSetup.JoinTeam")
            net.WriteUInt(ply:UserID(), 32)
            net.WriteUInt(teamID, 16)
        net.Broadcast()
    end)
end)

net.Receive("MinervaSetup.ChangeFaction", function(length, ply)
    local factionID = net.ReadUInt(16)

    if ( ply:GetFaction() == factionID ) then return end

    ply:SetFaction(factionID)

    timer.Simple(0.1, function()
        net.Start("MinervaSetup.ChangeFaction")
            net.WriteUInt(ply:UserID(), 32)
            net.WriteUInt(factionID, 16)
        net.Broadcast()
    end)
end)