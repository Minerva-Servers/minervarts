// Utility functions

function minerva.util:SendChatText(ply, ...)
    if ( !IsValid(ply) ) then return end

    if ( SERVER ) then
        net.Start("MinervaChatText")
            net.WriteTable({...})
        net.Send(ply)
    else
        chat.AddText(...)
    end
end

function minerva.util:PrintMessage(text, ply)
    if ( text == nil or text == "" ) then return end

    MsgC(Color(50, 125, 250), "[MINERVA] ", Color(150, 150, 150), text, "\n")

    if ( istable(ply) ) then
        for k, v in ipairs(ply) do
            self:SendChatText(v, Color(50, 125, 250), "[MINERVA] ", Color(150, 150, 150), text)
        end
    else
        if ( IsValid(ply) ) then
            self:SendChatText(ply, Color(50, 125, 250), "[MINERVA] ", Color(150, 150, 150), text)
        end
    end
end

function minerva.util:PrintError(text, ply)
    if ( text == nil or text == "" ) then return end

    MsgC(Color(50, 125, 250), "[MINERVA] ", Color(255, 0, 0), "[ERROR] ", Color(150, 150, 150), text, "\n")

    if ( istable(ply) ) then
        for k, v in ipairs(ply) do
            self:SendChatText(v, Color(50, 125, 250), "[MINERVA] ", Color(255, 0, 0), "[ERROR] ", Color(150, 150, 150), text)
        end
    else
        if ( IsValid(ply) ) then
            self:SendChatText(ply, Color(50, 125, 250), "[MINERVA] ", Color(255, 0, 0), "[ERROR] ", Color(150, 150, 150), text)
        end
    end
end

function minerva.util:PrintWarning(text, ply)
    if ( text == nil or text == "" ) then return end

    MsgC(Color(50, 125, 250), "[MINERVA] ", Color(255, 255, 0), "[WARNING] ", Color(150, 150, 150), text, "\n")

    if ( istable(ply) ) then
        for k, v in ipairs(ply) do
            self:SendChatText(v, Color(50, 125, 250), "[MINERVA] ", Color(255, 255, 0), "[WARNING] ", Color(150, 150, 150), text)
        end
    else
        if ( IsValid(ply) ) then
            self:SendChatText(ply, Color(50, 125, 250), "[MINERVA] ", Color(255, 255, 0), "[WARNING] ", Color(150, 150, 150), text)
        end
    end
end

function minerva.util:LoadFile(fileName, realm)
    if ( !fileName ) then
        self:PrintError("Failed to load file " .. fileName .. "!")
        return
    end

    if ( ( realm == "server" or string.find(fileName, "sv_") ) and SERVER ) then
        return include(fileName)
    elseif ( realm == "shared" or string.find(fileName, "shared.lua") or string.find(fileName, "sh_") ) then
        if ( SERVER ) then
            AddCSLuaFile(fileName)
        end

        return include(fileName)
    elseif ( realm == "client" or string.find(fileName, "cl_") ) then
        if ( SERVER ) then
            AddCSLuaFile(fileName)
        else
            return include(fileName)
        end
    end
end

function minerva.util:LoadFolder(directory, bFromLua)
    local baseDir = engine.ActiveGamemode()
    baseDir = baseDir .. "/gamemode/"

    for k, v in ipairs(file.Find(( bFromLua and "" or baseDir ) .. directory .. "/*.lua", "LUA")) do
        self:LoadFile(directory .. "/" .. v)
    end

    return true
end

function minerva.util:FindString(str, find)
    if ( !str or !find ) then return false end

    return tobool(string.find(string.lower(str), string.lower(find)))
end

function minerva.util:FindText(txt, find)
    if ( !txt or !find ) then return end

    local words = string.Explode(" ", txt)
    for k, v in ipairs(words) do
        if ( self:FindString(v, find) ) then
            return true
        end
    end

    return false
end

function minerva.util:FindPlayer(identifier)
    if ( !identifier ) then return end

    if ( type(identifier) == "Player" ) then
        return identifier
    end

    if ( type(identifier) == "string" ) then
        for k, v in player.Iterator() do
            if ( self:FindString(v:Name(), identifier) or self:FindString(v:SteamID(), identifier) or self:FindString(v:SteamID64(), identifier) ) then
                return v
            end
        end
    end

    if ( type(identifier) == "number" ) then
        return Player(identifier)
    end

    if ( type(identifier) == "table" ) then
        for k, v in ipairs(identifier) do
            return self:FindPlayer(v)
        end
    end
end

function minerva.util:GetBounds(startpos, endpos)
	local center = LerpVector(0.5, startpos, endpos)
	local min = WorldToLocal(startpos, angle_zero, center, angle_zero)
	local max = WorldToLocal(endpos, angle_zero, center, angle_zero)

    return center, min, max
end

function minerva.util:VectorToColor(vec, alpha)
    return Color(vec.x * 255, vec.y * 255, vec.z * 255, alpha or 255)
end

function minerva.util:ColorToVector(col)
    return Vector(col.r / 255, col.g / 255, col.b / 255)
end

function minerva.util:ColorDim(col, frac)
    return Color(col.r * frac, col.g * frac, col.b * frac, col.a)
end

function minerva.util:LerpColor(frac, from, to)
    return Color(
        Lerp(frac, from.r, to.r),
        Lerp(frac, from.g, to.g),
        Lerp(frac, from.b, to.b),
        Lerp(frac, from.a, to.a)
    )
end

function minerva.util:ColorRandom(min, max)
    min = min or 0
    max = max or 255

    return Color(math.random(min, max), math.random(min, max), math.random(min, max))
end

if ( CLIENT ) then
    local blur = Material("pp/blurscreen")
    local defaultAmount = 1
    local defaultPasses = 0.1
    function minerva.util:DrawBlur(panel, amount, passes)
        amount = amount or defaultAmount
        passes = passes or defaultPasses

        local x, y = panel:LocalToScreen(0, 0)
        local scrW, scrH = ScrW(), ScrH()

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)

        for i = -passes, 1, 0.2 do
            blur:SetFloat("$blur", (i / passes) * amount)
            blur:Recompute()

            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
        end
    end

    function minerva.util:DrawBlurRect(x, y, w, h, amount, passes)
        amount = amount or defaultAmount
        passes = passes or defaultPasses

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(blur)

        for i = -passes, 1, 0.2 do
            blur:SetFloat("$blur", (i / passes) * amount)
            blur:Recompute()

            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        end
    end
end