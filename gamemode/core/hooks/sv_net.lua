util.AddNetworkString("minervaWars.AbilityBuilding")

net.Receive("minervaWars.AbilityBuilding", function(len, ply)
    local ent = net.ReadEntity()

    if not ( IsValid(ent) ) then
        error("no valid entity found")
    end

    local ability = net.ReadString()

    if ( minerva.units.Get(ability) ) then
        print(ability)
        minerva.units.Create(ability, function(unit)
            unit:SetPos(ent:GetPos() + ent:GetAngles():Forward() * 256 + Vector(0, 0, 64))
        end)

        print("spawned unit")
    else
        error("failed to use ability")
    end
end)