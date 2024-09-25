// Client-side networking

net.Receive("MinervaChatText", function(len)
    local args = net.ReadTable()

    chat.AddText(unpack(args))
end)

net.Receive("MinervaSetup", function(len)
    vgui.Create("MinervaSetup")
end)

net.Receive("MinervaSetup.PopulatePlayers", function(len)
    local target = net.ReadUInt(32)
    local reason = net.ReadString()

    local setup = minerva.gui.setup
    if ( IsValid(setup) ) then
        setup:PopulatePlayers()
    end
end)

net.Receive("MinervaSetup.KickPlayer", function(len)
    local admin = net.ReadUInt(32)
    local name = net.ReadString()
    local reason = net.ReadString()

    if ( LocalPlayer():UserID() == admin ) then
        Derma_Message("You have kicked " .. name .. " for " .. reason .. ".", "Player Kicked", "OK")
    end
end)

net.Receive("MinervaSetup.JoinTeam", function(len)
    local ply = net.ReadUInt(32)
    local teamID = net.ReadUInt(16)

    if ( LocalPlayer():UserID() == ply ) then
        Derma_Message("You have joined team " .. team.GetName(teamID) .. ".", "Team Joined", "OK")
    end

    if ( IsValid(minerva.gui.setup) ) then
        minerva.gui.setup:PopulatePlayers()
    end
end)

net.Receive("MinervaSetup.ChangeFaction", function(len)
    local ply = net.ReadUInt(32)
    local factionID = net.ReadUInt(16)

    if ( LocalPlayer():UserID() == ply ) then
        Derma_Message("You have joined faction " .. minerva.factions:Get(factionID).Name .. ".", "Faction Joined", "OK")
    end

    if ( IsValid(minerva.gui.setup) ) then
        minerva.gui.setup:PopulatePlayers()
    end
end)