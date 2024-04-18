// Credit to the Helix Framework for the hook system
// https://github.com/NebulousCloud/helix/blob/master/gamemode/core/libs/sh_plugin.lua

minerva_hooks = {}

do
    // luacheck: globals hook
    hook.minervaCall = hook.minervaCall or hook.Call

    function hook.Call(name, gm, ...)
        local cache = minerva_hooks[name]

        if ( cache ) then
            for k, v in pairs(cache) do
                local a, b, c, d, e, f = v(k, ...)

                if ( a != nil ) then
                    return a, b, c, d, e, f
                end
            end
        end

        if ( SCHEMA and SCHEMA[name] ) then
            local a, b, c, d, e, f = SCHEMA[name](SCHEMA, ...)

            if ( a != nil ) then
                return a, b, c, d, e, f
            end
        end

        return hook.minervaCall(name, gm, ...)
    end

    /// Runs the given hook in a protected call so that the calling function will continue executing even if any errors occur
    // while running the hook. This function is much more expensive to call than `hook.Run`, so you should avoid using it unless
    // you absolutely need to avoid errors from stopping the execution of your function.
    // @internal
    // @realm shared
    // @string name Name of the hook to run
    // @param ... Arguments to pass to the hook functions
    // @treturn[1] table Table of error data if an error occurred while running
    // @treturn[1] ... Any arguments returned by the hook functions
    // @usage local errors, bCanSpray = hook.SafeRun("PlayerSpray", Entity(1))
    // if not ( errors ) then
    // 	// do stuff with bCanSpray
    // else
    // 	PrintTable(errors)
    // end

    function hook.SafeRun(name, ...)
        local errors = {}
        local gm = gmod and gmod.GetGamemode() or nil
        local cache = minerva_hooks[name]

        if ( cache ) then
            for k, v in pairs(cache) do
                local bSuccess, a, b, c, d, e, f = pcall(v, k, ...)
                if ( bSuccess ) then
                    if ( a != nil ) then
                        return errors, a, b, c, d, e, f
                    end
                else
                    ErrorNoHalt(string.format("[Minerva] hook.SafeRun error for plugin hook \"%s:%s\":\n\t%s\n%s\n",
                        tostring(k and k.uniqueID or nil), tostring(name), tostring(a), debug.traceback()))

                    errors[#errors + 1] = {
                        name = name,
                        plugin = k and k.uniqueID or nil,
                        errorMessage = tostring(a)
                    }
                end
            end
        end

        if ( SCHEMA and SCHEMA[name] ) then
            local bSuccess, a, b, c, d, e, f = pcall(SCHEMA[name], SCHEMA, ...)
            if ( bSuccess ) then
                if ( a != nil ) then
                    return errors, a, b, c, d, e, f
                end
            else
                ErrorNoHalt(string.format("[Minerva] hook.SafeRun error for schema hook \"%s\":\n\t%s\n%s\n",
                    tostring(name), tostring(a), debug.traceback()))

                errors[#errors + 1] = {
                    name = name,
                    schema = SCHEMA.name,
                    errorMessage = tostring(a)
                }
            end
        end

        local bSuccess, a, b, c, d, e, f = pcall(hook.minervaCall, name, gm, ...)
        if ( bSuccess ) then
            return errors, a, b, c, d, e, f
        else
            ErrorNoHalt(string.format("[Minerva] hook.SafeRun error for gamemode hook \"%s\":\n\t%s\n%s\n",
                tostring(name), tostring(a), debug.traceback()))

            errors[#errors + 1] = {
                name = name,
                gamemode = "gamemode",
                errorMessage = tostring(a)
            }

            return errors
        end
    end
end