minerva.paths = minerva.paths or {}

/// Finds a path from the start to the goal using the A* algorithm
function minerva.paths:FindPath(start, goal)
    if ( !IsValid(start) or !IsValid(goal) ) then return end
    if ( start == goal ) then return end

    start:ClearSearchLists()

    start:AddToOpenList()

    local cameFrom = {}

    start:SetCostSoFar(0)

    start:SetTotalCost(self:Estimate(start, goal))
    start:UpdateOnOpenList()

    while ( !start:IsOpenListEmpty() ) do
        local current = start:PopOpenList() // Remove the area with lowest cost in the open list and return it
        if ( current == goal ) then
            return self:Reconstruct(cameFrom, current)
        end

        current:AddToClosedList()

        for k, neighbor in pairs(current:GetAdjacentAreas()) do
            local newCostSoFar = current:GetCostSoFar() + self:Estimate(current, neighbor)

            if ( neighbor:IsUnderwater() ) then continue end
            
            if ( ( neighbor:IsOpen() or neighbor:IsClosed() ) and neighbor:GetCostSoFar() <= newCostSoFar ) then
                continue
            else
                neighbor:SetCostSoFar(newCostSoFar)
                neighbor:SetTotalCost(newCostSoFar + self:Estimate(neighbor, goal))

                if ( neighbor:IsClosed() ) then
                    neighbor:RemoveFromClosedList()
                end

                if ( neighbor:IsOpen() ) then
                    // This area is already on the open list, update its position in the list to keep costs sorted
                    neighbor:UpdateOnOpenList()
                else
                    neighbor:AddToOpenList()
                end

                cameFrom[neighbor:GetID()] = current:GetID()
            end
        end
    end

    return false
end

/// Returns the estimated cost from the start to the goal
// Perhaps play with some calculations on which corner is closest/farthest or whatever
function minerva.paths:Estimate(start, goal)
    return start:GetCenter():Distance(goal:GetCenter())
end

/// Reconstructs the path from the start to the goal using the cameFrom table
// using CNavAreas as table keys doesn't work, we use IDs
function minerva.paths:Reconstruct(cameFrom, current)
    local total_path = {current}

    current = current:GetID()

    while ( cameFrom[current] ) do
        current = cameFrom[current]
        table.insert(total_path, navmesh.GetNavAreaByID(current))
    end

    return total_path
end

/// Returns all the paths from the start to the goal as vectors in a table
function minerva.paths:GetPathVectors(path, bRandom)
    local vectors = {}

    for _, area in SortedPairs(path, true) do
        table.insert(vectors, bRandom and area:GetRandomPoint() or area:GetCenter())
    end

    return vectors
end

/// Draws the path on the screen
function minerva.paths:DrawPath(path, time)
    time = time or 9

    local vectors = self:GetPathVectors(path)
    for i = 1, #vectors - 1 do
        debugoverlay.Line(vectors[i], vectors[i + 1], time, Color(255, 0, 0))
        debugoverlay.Text(vectors[i], i, time)
        debugoverlay.Sphere(vectors[i], 10, time, Color(0, 255, 0))
        debugoverlay.Sphere(vectors[i + 1], 10, time, Color(0, 255, 0))
    end
end

/// Console command to find a path from the player's position to the aim position
concommand.Add("minerva_paths_find", function(ply, cmd, args)
    // Use the start position of the player who ran the console command
    local start = navmesh.GetNearestNavArea(ply:GetPos())

    // Target position, use the player's aim position for this example
    local goal = navmesh.GetNearestNavArea(ply:GetEyeTrace().HitPos)

    local path = minerva.paths:FindPath(start, goal)
    
    // We can't physically get to the goal or we are in the goal.
    if ( !istable(path) ) then return end

    PrintTable(path) // Print the generated path to console for debugging
    minerva.paths:DrawPath(path) // Draw the generated path for 9 seconds
end)

local airNPCs = {
    ["npc_helicopter"] = true,
    ["npc_combinegunship"] = true,
    ["npc_combinedropship"] = true,
}

function minerva.paths:MoveNPC(npc, pos, bRandom)
    if ( !IsValid(npc) ) then print("Invalid NPC!") return end
    if ( !pos ) then print("Invalid pos!") return end

    local class = npc:GetClass()
    if ( airNPCs[class] ) then
        for k, v in ipairs(ents.FindByName("path_track_" .. npc:EntIndex() .. "_*")) do
            print("Removed: " .. v:GetName())
            SafeRemoveEntity(v)
        end

        local start = navmesh.GetNearestNavArea(npc:GetPos())
        local goal = navmesh.GetNearestNavArea(pos)

        local path = self:FindPath(start, goal)
        if ( !istable(path) ) then return end

        local vectors = self:GetPathVectors(path, bRandom)
        local pathTrack
        local pathTracks = {}
        for k, v in ipairs(vectors) do
            local name = "path_track_" .. npc:EntIndex() .. "_" .. k
            local target = "path_track_" .. npc:EntIndex() .. "_" .. (k + 1)
            
            pathTrack = ents.Create("path_track")
            pathTrack:SetPos(v + Vector(0, 0, 512))
            pathTrack:SetName(name)
            pathTrack:SetKeyValue("orientationtype", 2)

            debugoverlay.Sphere(pathTrack:GetPos(), 10, 9, Color(255, 0, 0))
            debugoverlay.Text(pathTrack:GetPos(), pathTrack:GetName(), 9)

            print("Created: " .. name)

            if ( k < #vectors ) then
                print("Target: " .. target)
                pathTrack:SetKeyValue("target", target)
            end

            print("\n")

            pathTrack:Spawn()
            
            local nextPos = vectors[k + 1]
            if ( nextPos ) then
                local dir = (nextPos - v):GetNormalized()
                local ang = dir:Angle()
                ang:RotateAroundAxis(ang:Up(), 90)

                pathTrack:SetAngles(ang)

                debugoverlay.Line(pathTrack:GetPos(), nextPos + Vector(0, 0, 512), 9, Color(0, 255, 0))
                debugoverlay.Cross(nextPos + Vector(0, 0, 512), 10, 9, Color(0, 255, 0))
            end
            
            npc:DeleteOnRemove(pathTrack)

            if ( k == 1 ) then
                timer.Simple(1, function()
                    print("Flying to: " .. name)
                    npc:Fire("FlyToSpecificTrackViaPath", name)
                end)
            end

            table.insert(pathTracks, pathTrack)
        end

        self:DrawPath(path)
    elseif ( class == "prop_vehicle_apc" ) then
        local driver
        for k2, v2 in ipairs(ents.FindByClass("npc_apcdriver")) do
            local var = v2:GetInternalVariable("Vehicle")
            if ( var == npc:GetName() ) then
                driver = v2
                break
            end
        end

        if ( IsValid(driver) ) then
            local start = navmesh.GetNearestNavArea(npc:GetPos())
            local goal = navmesh.GetNearestNavArea(pos)

            local path = self:FindPath(start, goal)
            if ( !istable(path) ) then return end

            local vectors = self:GetPathVectors(path, bRandom)
            local pathCorner
            local pathCorners = {}
            for k, v in ipairs(vectors) do
                local name = "path_corner_" .. driver:EntIndex() .. "_" .. k
                local target = "path_corner_" .. driver:EntIndex() .. "_" .. (k + 1)

                pathCorner = ents.Create("path_corner")
                pathCorner:SetPos(v)
                pathCorner:SetName(name)

                debugoverlay.Sphere(v, 10, 9, Color(255, 0, 0))

                print("Created: " .. name)

                if ( k < #vectors ) then
                    print("Target: " .. target)
                    pathCorner:SetKeyValue("target", target)
                end

                print("\n")

                pathCorner:Spawn()

                pathCorner:Fire("AddOutput", "OnPass !self,Kill,,0,-1", 0)
                npc:DeleteOnRemove(pathCorner)

                debugoverlay.Text(pathCorner:GetPos(), pathCorner:GetName(), 9)
                debugoverlay.Box(pathCorner:GetPos(), Vector(-5, -5, -5), Vector(5, 5, 5), 9, Color(0, 0, 255))

                table.insert(pathCorners, pathCorner)
            end

            driver:Fire("GotoPathCorner", pathCorners[1]:GetName())
            driver:Fire("SetDriversMaxSpeed", 0.5)
            driver:Fire("SetDriversMinSpeed", 0)
            driver:Fire("StartForward")

            self:DrawPath(path)
        end
    else
        npc:SetLastPosition(pos)
        npc:SetSchedule(npc:GetNetVar("walking") and SCHED_FORCED_GO or SCHED_FORCED_GO_RUN)
    end
end
