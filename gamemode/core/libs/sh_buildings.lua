minerva.buildings = minerva.buildings or {}
minerva.buildings.stored = minerva.buildings.stored or {}

function minerva.buildings:LoadFolder()
    local path = "minervarts/schema/buildings"
    local bSuccess = false
    
    if ( file.Exists(path, "LUA") ) then
        bSuccess = minerva.util:LoadFolder("minervarts/schema/buildings", true)
    end

    if ( !bSuccess ) then
        minerva:PrintError("Buildings not found!")
        return
    end

    hook.Run("BuildingsLoad", path)

    minerva.util:PrintMessage("Loaded buildings.")

    hook.Run("BuildingsLoaded", path)

    return true
end

function minerva.buildings:Register(info)
    hook.Run("PreBuildingRegister", info)

    local UniqueID = string.lower(string.gsub(info.Name, "%s", "_"))
    UniqueID = "minerva_building_" .. UniqueID

    if ( self.stored[UniqueID] ) then
        minerva.util:PrintWarning("Building " .. info.Name .. " already exists! Overwriting...")
        self.stored[UniqueID] = nil
    else
        minerva.util:PrintMessage("Registered " .. info.Name .. " unit.")
    end

    info.UniqueID = UniqueID

    if ( info.Base ) then
        local base = self:Get(info.Base)
        if ( !base ) then
            minerva.util:PrintError("Attempted to register building with invalid base!")
            return
        end

        info = table.Inherit(info, base)
        info.Base = nil
    end

    self.stored[UniqueID] = info

    local entityTable = {
        Type = "anim",
        Base = "base_anim",
        Category = "Minerva Servers - RTS: " .. ( info.Category or "Unknown" ),
        PrintName = info.Name,
        Author = "Riggs",
        Spawnable = true,
        AdminOnly = true
    }

    entityTable.Initialize = function(this)
        this:SetModel(info.Model)

        this:SetSolid(SOLID_VPHYSICS)
        this:SetMoveType(MOVETYPE_VPHYSICS)
        this:PhysicsInit(SOLID_VPHYSICS)

        if ( SERVER ) then
            this:SetUseType(SIMPLE_USE)

            local physObj = this:GetPhysicsObject()
            if ( IsValid(physObj) ) then
                physObj:Wake()
            end

            this:SetHealth(info.Health)
            this:SetMaxHealth(info.Health)
        end

        if ( info.CustomInitialize ) then
            info.CustomInitialize(this)
        end
    end

    scripted_ents.Register(entityTable, UniqueID)

    hook.Run("BuildingRegistered", info)

    return self.stored[UniqueID]
end

function minerva.buildings:Get(identifier)
    if ( !identifier ) then
        minerva.util:PrintError("Attempted to get unit with nil identifier!")
        return
    end

    if ( istable(identifier) ) then
        identifier = identifier.UniqueID
    end

    for k, v in pairs(self.stored) do
        if ( minerva.util:FindText(v.Name, identifier) or minerva.util:FindText(v.UniqueID, identifier) ) then
            return v
        end
    end

    return self.stored[identifier]
end