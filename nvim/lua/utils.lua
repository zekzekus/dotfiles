_G.prequire = function(plugin, verbose)
    local present, plug = pcall(require, plugin)
    if present then
        return plug
    end
    local errmsg = string.format("Could not load %s", plugin)
    if verbose then
        errmsg = string.format("%s\nError:%s", plug)
    end
    print(errmsg)
end

_G.default_config = function(plugin)
    local plug = prequire(plugin)
    if not plug then
        return
    end
    plug.setup({})
end
