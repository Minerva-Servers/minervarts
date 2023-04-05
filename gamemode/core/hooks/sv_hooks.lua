function GM:PlayerInitialSpawn(ply)
    ply:KillSilent()

    // Randomly assign a faction to the player
    if ( math.random(2) == 1 ) then
        ply:SetTeam(FACTION_REBELS)
    else
        ply:SetTeam(FACTION_COMBINE)
    end

    timer.Simple(10, function()
        ply:Respawn()
    end)
end


function GM:PlayerSpawn(ply)
    local spawnPos = table.Random(ents.FindByClass("info_player_start")):GetPos()
    ply:SetPos(spawnPos)

    local trace = util.TraceLine({
        start = ply:GetPos(),
        endpos = ply:GetPos() - Vector(0, 0, 1000),
        mask = MASK_PLAYERSOLID,
        filter = ply
    })

    // Spawn the entity below the player at the hit position
    minerva.buildings.Create(BUILDING_REBEL_HQ, function(ent)
        ent:SetPos(trace.HitPos)
        ent:DropToFloor()

        ply:SetPos(ent:GetPos() + Vector(0, 0, 2000))
    end)
end