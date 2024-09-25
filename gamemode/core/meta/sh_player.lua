// Player meta functions

local PLAYER = FindMetaTable("Player")

PLAYER.SteamName = PLAYER.SteamName or PLAYER.Name

function PLAYER:GetFaction()
    return self:GetNetVar("faction", 0)
end

if ( SERVER ) then
    function PLAYER:SetFaction(factionID)
        if ( !factionID ) then
            error("Attempt to set faction to nil.")
        end

        if ( !isnumber(factionID) ) then
            error("Attempt to set faction to non-number.")
        end
        
        if ( !minerva.factions:Get(factionID) ) then
            error("Attempt to set faction to invalid faction.")
        end

        self:SetNetVar("faction", factionID)
    end
end