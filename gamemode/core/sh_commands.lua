// Commands

/*
minerva.commands:Register({
    Name = "test",
    AdminOnly = true,
    SuperAdminOnly = true,
    Callback = function(ply, arguments)
        ply:ChatPrint("Test command ran!")
    end
})

minerva.commands:Register({
    Name = "Respawn",
    AdminOnly = true,
    Callback = function(ply, arguments)
        ply:Spawn()
    end
})

minerva.commands:Register({
    Name = "SetHealth",
    AdminOnly = true,
    Callback = function(ply, arguments)
        local target = minerva:FindPlayer(arguments[1])
        if not ( IsValid(target) ) then
            minerva:PrintError("Attempted to set health on an invalid player!", ply)
            return
        end

        local health = tonumber(arguments[2])
        if not ( health ) then
            minerva:PrintError("Attempted to set health with an invalid health value!", ply)
            return
        end

        target:SetHealth(health)

        minerva:PrintMessage(ply:Name() .. " set " .. target:Name() .. "'s health to " .. health)
    end
})
*/