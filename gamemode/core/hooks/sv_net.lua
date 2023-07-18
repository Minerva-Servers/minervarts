local util_AddNetworkString = util.AddNetworkString
local net_Receive = net.Receive
local net_ReadEntity = net.ReadEntity
local IsValid = IsValid
local error = error
local net_ReadString = net.ReadString
local minerva = minerva
local print = print
local Vector = Vector

util_AddNetworkString("minervaWars.AbilityBuilding")

net_Receive("minervaWars.AbilityBuilding", function(len, ply)
    local ent = net_ReadEntity()

    if not ( IsValid(ent) ) then
        error("no valid entity found")
    end

    local ability = net_ReadString()

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