local math_random = math.random
local timer_Simple = timer.Simple
local table_Random = table.Random
local ents_FindByClass = ents.FindByClass
local util_TraceLine = util.TraceLine
local Vector = Vector
local minerva = minerva

function GM:PlayerInitialSpawn(ply)
    ply:KillSilent()

    // Randomly assign a faction to the player
    if ( math_random(2) == 1 ) then
        ply:SetTeam(FACTION_REBELS)
    else
        ply:SetTeam(FACTION_COMBINE)
    end

    timer_Simple(10, function()
        ply:Respawn()
    end)
end


function GM:PlayerSpawn(ply)
    local spawnPos = table_Random(ents_FindByClass("info_player_start")):GetPos()
    ply:SetPos(spawnPos)

    local trace = util_TraceLine({
        start = ply:GetPos(),
        endpos = ply:GetPos() - Vector(0, 0, 1000),
        mask = MASK_PLAYERSOLID,
        filter = ply,
    })

    // Spawn the entity below the player at the hit position
    minerva.buildings.Create(minerva.factions.Get(ply:Team()).startBuilding, function(ent)
        ent:SetPos(trace.HitPos)
        ent:DropToFloor()

        ply:SetPos(ent:GetPos() + Vector(0, 0, 2000))
    end)
end