function minerva:SendChatText(ply, ...)
    if not ( ply ) then
        return
    end

    if ( SERVER ) then
        net.Start("MinervaChatText")
            net.WriteTable({...})
        net.Send(ply)
    else
        chat.AddText(...)
    end
end

function minerva:PrintMessage(text, ply)
    if ( text == nil or text == "" ) then
        return
    end

    MsgC(Color(50, 125, 250), "[Minerva] ", Color(250, 125, 50), "[RTS] ", Color(150, 150, 150), text, "\n")

    if ( IsValid(ply) ) then
        self:SendChatText(ply, Color(50, 125, 250), "[Minerva] ", Color(250, 125, 50), "[RTS] ", Color(150, 150, 150), text)
    end
end

function minerva:PrintError(text, ply)
    if ( text == nil or text == "" ) then
        return
    end

    MsgC(Color(50, 125, 250), "[Minerva] ", Color(250, 125, 50), "[RTS] ", Color(255, 0, 0), "[ERROR] ", Color(150, 150, 150), text, "\n")

    if ( IsValid(ply) ) then
        self:SendChatText(ply, Color(50, 125, 250), "[Minerva] ", Color(250, 125, 50), "[RTS] ", Color(255, 0, 0), "[ERROR] ", Color(150, 150, 150), text)
    end
end

function minerva:PrintWarning(text, ply)
    if ( text == nil or text == "" ) then
        return
    end

    MsgC(Color(50, 125, 250), "[Minerva] ", Color(250, 125, 50), "[RTS] ", Color(255, 255, 0), "[WARNING] ", Color(150, 150, 150), text, "\n")

    if ( IsValid(ply) ) then
        self:SendChatText(ply, Color(50, 125, 250), "[Minerva] ", Color(250, 125, 50), "[RTS] ", Color(255, 255, 0), "[WARNING] ", Color(150, 150, 150), text)
    end
end

function minerva:LoadFile(path, realm)
    if not ( path or file.Exists("minervarts" .. "/gamemode/" .. path, "LUA") ) then
        minerva:PrintError("Failed to load file " .. path)
        return
    end

    realm = realm or "shared"
    realm = string.lower(realm)
    
    minerva:PrintMessage("Loaded file \"" .. path .. "\".")

    if ( realm == "server" or string.find(path, "sv_") and SERVER ) then
        return include(path)
    elseif ( realm == "client" or string.find(path, "cl_") ) then
        if ( SERVER ) then
            AddCSLuaFile(path)
        else
            return include(path)
        end
    elseif ( realm == "shared" or string.find(path, "sh_") ) then
        if ( SERVER ) then
            AddCSLuaFile(path)
        end

        return include(path)
    end
end

function minerva:LoadFolder(directory, bFromLua)
    local baseDir = "minervarts"

    if ( bFromLua ) then
        baseDir = baseDir
    else
        baseDir = baseDir .. "/gamemode/"
    end

    for k, v in ipairs(file.Find(( bFromLua and "" or baseDir ) .. directory .. "/*.lua", "LUA")) do
        minerva:LoadFile(directory .. "/" .. v)
        
        if ( file.IsDir(directory .. "/" .. v, "LUA") ) then
            minerva:LoadFolder(directory .. "/" .. v, true)
        end
    end

    minerva:PrintMessage("Loaded folder \"" .. directory .. "\".")

    return true
end

function minerva:FindPlayer(identifier)
    if not ( identifier ) then
        return
    end

    if ( type(identifier) == "Player" ) then
        return identifier
    end

    if ( type(identifier) == "string" ) then
        for k, v in player.Iterator() do
            if ( string.find(string.lower(v:Name()), string.lower(identifier)) ) then
                return v
            end
        end
    end

    if ( type(identifier) == "number" ) then
        return player.GetByID(identifier)
    end
end

function minerva:GetBounds(startpos, endpos)
	local center = LerpVector(0.5, startpos, endpos)
	local min = WorldToLocal(startpos, angle_zero, center, angle_zero)
	local max = WorldToLocal(endpos, angle_zero, center, angle_zero)

    return center, min, max
end