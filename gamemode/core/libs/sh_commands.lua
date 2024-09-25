minerva.commands = minerva.commands or {}
minerva.commands.stored = minerva.commands.stored or {}

function minerva.commands:Register(info)
    if ( !info ) then
        minerva.util:PrintError("Attempted to register an invalid command!")
        return
    end

    if ( !info.Name ) then
        minerva.util:PrintError("Attempted to register a command with no name!")
        return
    end

    if ( !info.Callback ) then
        minerva.util:PrintError("Attempted to register a command with no callback!")
        return
    end

    if ( !info.Prefixes ) then
        minerva.util:PrintError("Attempted to register a command with no prefixes!")
        return
    end

    local uniqueID = string.lower(string.gsub(info.Name, "%s", "_"))
    uniqueID = info.uniqueID or uniqueID

    self.stored[uniqueID] = info

    return info
end

function minerva.commands:UnRegister(name)
    self.stored[name] = nil
end

function minerva.commands:Get(identifier)
    if ( !identifier ) then
        minerva.util:PrintError("Attempted to get an invalid command!")
        return
    end

    if ( self.stored[identifier] ) then
        return self.stored[identifier]
    end

    for k, v in pairs(self.stored) do
        for k2, v2 in pairs(v.Prefixes) do
            if ( minerva.util:FindString(v2, identifier) ) then
                return v
            end
        end
    end

    minerva.util:PrintError("Attempted to get an invalid command!")

    return
end

if ( CLIENT ) then
    return
end

function minerva.commands:Run(ply, command, arguments)
    if ( !IsValid(ply) ) then
        minerva.util:PrintError("Attempted to run a command with no player!")
        return
    end

    if ( !command ) then
        minerva.util:PrintError("Attempted to run a command with no command!", ply)
        return
    end

    local info = self:Get(command)
    if ( !info ) then
        minerva.util:PrintError("Attempted to run an invalid command!", ply)
        return
    end

    if ( info.AdminOnly and !ply:IsAdmin() ) then
        minerva.util:PrintError("Attempted to run an admin-only command!", ply)
        return
    end

    if ( info.SuperAdminOnly and !ply:IsSuperAdmin() ) then
        minerva.util:PrintError("Attempted to run a superadmin-only command!", ply)
        return
    end

    info:Callback(ply, arguments)
end

concommand.Add("minerva_command_run", function(ply, cmd, arguments)
    if ( !IsValid(ply) ) then
        minerva.util:PrintError("Attempted to run a command with no player!")
        return
    end

    local command = arguments[1]
    table.remove(arguments, 1)

    minerva.commands:Run(ply, command, arguments)

    ply.minervaNextCommand = CurTime() + 1
end)

concommand.Add("minerva_command_list", function(ply, cmd, arguments)
    if ( !IsValid(ply) ) then
        minerva.util:PrintError("Attempted to list commands with no player!")
        return
    end

    if ( ply.minervaNextCommand and ply.minervaNextCommand > CurTime() ) then
        return
    end

    minerva.util:PrintMessage("Commands:", ply)

    for k, v in pairs(minerva.commands.stored) do
        if ( v.AdminOnly and !ply:IsAdmin() ) then
            continue
        end

        if ( v.SuperAdminOnly and !ply:IsSuperAdmin() ) then
            continue
        end

        if ( v.Description ) then
            minerva.util:PrintMessage("/" .. v.Name .. " - " .. v.Description, ply)
        else
            minerva.util:PrintMessage("/" .. v.Name, ply)
        end
    end

    ply.minervaNextCommand = CurTime() + 1
end)