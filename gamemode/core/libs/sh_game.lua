minerva.game = minerva.game or {}

function minerva.game:CanStartGame(ply)
    local admins = {}
    for k, v in ipairs(player.GetHumans()) do
        if ( v:IsAdmin() ) then
            table.insert(admins, v)
        end
    end

    if ( GetNetVar("lobbyOwner", NULL) == NULL or #admins == 0 ) then
        return false, "There is no lobby owner."
    end

    if ( GetNetVar("lobbyOwner", NULL) != ply and !ply:IsAdmin() ) then
        return false, "You are not the lobby owner."
    end

    if ( #player.GetHumans() < 2 ) then
        return false, "There are not enough players."
    end

    return true
end

function minerva.game:StartGame(ply)
    local canStart, reason = minerva.game:CanStartGame(ply)
    if ( !canStart ) then
        minerva.util:PrintError(reason, ply)
        return
    end

    SetNetVar("gameStarted", true)

    for k, v in ipairs(player.GetHumans()) do
        v:KillSilent()
    end

    timer.Simple(1, function()
        for k, v in ipairs(player.GetHumans()) do
            v:Spawn()
        end
    end)
end