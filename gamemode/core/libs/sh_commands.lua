minerva.commands = minerva.commands or {}
minerva.commands.stored = minerva.commands.stored or {}

function minerva.commands:Register(info)
    if not ( info ) then
        minerva:PrintError("Attempted to register an invalid command!")
        return
    end

    if not ( info.Name ) then
        minerva:PrintError("Attempted to register a command with no name!")
        return
    end

    if not ( info.Callback ) then
        minerva:PrintError("Attempted to register a command with no callback!")
        return
    end

    local uniqueID = string.lower(string.gsub(info.Name, "%s", "_"))
    uniqueID = "minerva_" .. uniqueID
    uniqueID = info.uniqueID or uniqueID

    if ( minerva.commands.stored[uniqueID] ) then
        minerva:PrintWarning("Command \"" .. info.Name .. "\" already exists! Overwriting...")
        minerva.commands.stored[uniqueID] = nil
    end

    minerva.commands.stored[uniqueID] = info

    return info
end

function minerva.commands:Get(identifier)
    if not ( identifier ) then
        minerva:PrintError("Attempted to get an invalid command!")
        return
    end

    if ( minerva.commands.stored[identifier] ) then
        return minerva.commands.stored[identifier]
    end

    for k, v in pairs(minerva.commands.stored) do
        if ( string.find(string.lower(v.Name), string.lower(identifier)) ) then
            return v
        end
    end
end

if ( CLIENT ) then
    return
end

function minerva.commands:Run(ply, command, arguments)
    if not ( IsValid(ply) ) then
        minerva:PrintError("Attempted to run a command with no player!")
        return
    end

    if not ( command ) then
        minerva:PrintError("Attempted to run a command with no command!", ply)
        return
    end

    local commandTable = self:Get(command)
    if not ( commandTable ) then
        minerva:PrintError("Attempted to run an invalid command!", ply)
        return
    end

    if ( commandTable.AdminOnly and not ply:IsAdmin() ) then
        minerva:PrintError("Attempted to run an admin-only command!", ply)
        return
    end

    if ( commandTable.SuperAdminOnly and not ply:IsSuperAdmin() ) then
        minerva:PrintError("Attempted to run a superadmin-only command!", ply)
        return
    end

    commandTable.Callback(ply, arguments)
end

concommand.Add("minerva_run_command", function(ply, _, arguments)
    local command = arguments[1]
    table.remove(arguments, 1)

    minerva.commands:Run(ply, command, arguments)
end)

hook.Add("PlayerSay", "minerva_Commands", function(ply, text)
    if ( string.sub(text, 1, 1) == "/" ) then
        local arguments = string.Explode(" ", string.sub(text, 2))
        local command = arguments[1]
        table.remove(arguments, 1)

        minerva.commands:Run(ply, command, arguments)

        return ""
    end
end)