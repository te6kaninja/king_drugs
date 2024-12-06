local modules <const>, resource <const>, context <const> = {
    'devtools',
    'weed'
}, cache.resource, lib.context

local globalVarName <const> = select(2, string.strsplit('_', resource))

local function requiremod(module, mod)
    return require(('code.modules.%s.mods.%s'):format(module, mod))
end

_ENV[globalVarName] = {
    requireMod = requiremod,
    exports = {}
    -- Shared values
}

CreateThread(function()
    for i = 1, #modules do
        local moduleName <const> = modules[i]

        _ENV[globalVarName][moduleName] = {
            requireMod = function(mod)
                return requiremod(moduleName, mod)
            end
        }

        require(('code.modules.%s.%s'):format(moduleName, context))
    end

    for name, func in pairs(_ENV[globalVarName].exports) do
        if type(func) == 'function' then
            exports(name, func)
        end
    end
end)