gmodwars.util = gmodwars.util or {}

function gmodwars.util.Include(fileName, realm)
	if not ( fileName ) then
		error("[Gmod Wars] No file name specified for including.")
	end
	
	if ( ( realm == "server" or fileName:find("sv_") ) and SERVER ) then
		return include(fileName)
	elseif ( realm == "shared" or fileName:find("shared.lua") or fileName:find("sh_")) then
		if ( SERVER) then
			AddCSLuaFile(fileName)
		end

		return include(fileName)
	elseif ( realm == "client" or fileName:find("cl_") ) then
		if ( SERVER ) then
			AddCSLuaFile(fileName)
		else
			return include(fileName)
		end
	end
end

function gmodwars.util.IncludeDirectory(directory, bFromLua)
	local baseDir = "gmodwars/gamemode/"

	for _, v in ipairs(file.Find((bFromLua and "" or baseDir)..directory.."/*.lua", "LUA")) do
		gmodwars.util.Include(directory.."/"..v)
	end
end

gmodwars.util.materials = gmodwars.util.materials or {}

function gmodwars.util.GetMaterial(mat, ...)
	if not ( gmodwars.util.materials[mat] ) then
		gmodwars.util.materials[mat] = Material(mat, ...)
	end

	return gmodwars.util.materials[mat]
end

function gmodwars.util.GetPlayerByName(find, bMultiple)
	bMultiple = bMultiple and true or false

	local find_lower = find:lower()

	local players = {}

	for i, v in ipairs(player.GetAll()) do
		local pname = v:GetName()
		local pname_lower = pname:lower()

		if ( pname == find ) then
			players[#players + 1] = v
			continue
		end

		if ( pname:match(find) ) then
			players[#players + 1] = v
			continue
		end

		if ( pname_lower == find_lower ) then
			players[#players + 1] = v
			continue
		end

		if ( pname_lower:match(find_lower) ) then
			players[#players + 1 ] = v
			continue
		end
	end

	if ( bMultiple ) then
		return players
	end

	return players[1]
end