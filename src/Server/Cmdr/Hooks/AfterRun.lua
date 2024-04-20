local RunService = game:GetService("RunService")

function hook(context)
    if RunService:IsClient() then return end
    print(`{context.Executor} has ran the "{context.Name}" command. Full invocation: "{context.RawText}"`)
end

function register(registry)
    registry:RegisterHook("AfterRun", hook)
end

return register