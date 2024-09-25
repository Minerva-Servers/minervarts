minerva.hooks = minerva.hooks or {}
minerva.hooks.stored = minerva.hooks.stored or {}

function minerva.hooks:Register(name)
    self.stored[name] = true
end

function minerva.hooks:UnRegister(name)
    self.stored[name] = nil
end

hook.minervaCall = hook.minervaCall or hook.Call

function hook.Call(name, gm, ...)
    for k, v in pairs(minerva.hooks.stored) do
        local tab = _G[k]
        if ( !tab ) then continue end

        local fn = tab[name]
        if ( !fn ) then continue end

        local a, b, c, d, e, f = fn(tab, ...)

        if ( a != nil ) then
            return a, b, c, d, e, f
        end
    end

    for k, v in pairs(minerva.modules.stored) do
        for k2, v2 in pairs(v) do
            if ( type(v2) == "function" ) then
                if ( k2 == name ) then
                    local a, b, c, d, e, f = v2(v, ...)

                    if ( a != nil ) then
                        return a, b, c, d, e, f
                    end
                end
            end
        end
    end

    return hook.minervaCall(name, gm, ...)
end