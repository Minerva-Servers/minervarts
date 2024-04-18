minerva.modules = minerva.modules or {}
minerva.modules.stored = {}

function minerva.modules:Register(info)
    if not ( info ) then
        minerva:PrintError("Attempted to register an invalid module!")
        return
    end

    if not ( info.Name ) then
        info.Name = "Unknown"
    end

    if not ( info.Description ) then
        info.Description = "No description provided."
    end

    if not ( info.Author ) then
        info.Author = "Unknown"
    end

    for k, v in pairs(info) do
        if ( type(v) == "function" ) then
            minerva_hooks[k] = minerva_hooks[k] or {}
            minerva_hooks[k][info] = v
        end
    end

    minerva.modules.stored[info] = info

    minerva:PrintMessage("Registered " .. info.Name .. " module.")

    return info
end

function minerva.modules:Get(identifier)
    if not ( identifier ) then
        minerva:PrintError("Attempted to get an invalid module!")
        return
    end

    if ( minerva.modules.stored[identifier] ) then
        return minerva.modules.stored[identifier]
    end

    for k, v in pairs(minerva.modules.stored) do
        if ( string.find(string.lower(v.Name), string.lower(identifier)) ) then
            return v
        end
    end
end

function minerva.modules:AddFunction(module, hook, func)
    if not ( module ) then
        minerva:PrintError("Attempted to add a function to an invalid module!")
        return
    end

    if not ( hook ) then
        minerva:PrintError("Attempted to add a function to an invalid hook!")
        return
    end

    if not ( func ) then
        minerva:PrintError("Attempted to add an invalid function!")
        return
    end

    local moduleInfo = minerva.modules:Get(module)

    if not ( moduleInfo ) then
        minerva:PrintError("Attempted to add a function to an invalid module!")
        return
    end

    minerva_hooks[hook] = minerva_hooks[hook] or {}
    minerva_hooks[hook][moduleInfo] = func

    minerva:PrintMessage("Added function to " .. moduleInfo.Name .. " module.")
end