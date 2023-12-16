function hook(context)
    -- TODO: Add permissions system.
end

function register(registry)
    registry:RegisterHook("BeforeRun", hook)
end

return register