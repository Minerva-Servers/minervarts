// Commands

minerva.commands:Register({
    Name = "Respawn",
    Prefixes = {"Respawn"},
    AdminOnly = true,
    Callback = function(info, ply, arguments)
        local target = minerva.util:FindPlayer(arguments[1])
        if ( !IsValid(target) ) then
            minerva.util:PrintError("Attempted to respawn an invalid player!", ply)
            return
        end

        target:KillSilent()
        target:Spawn()

        minerva.util:PrintMessage(ply:Name() .. " respawned " .. target:Name(), ply)
    end
})