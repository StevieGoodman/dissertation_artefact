local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)

function hook(context)
    local result = Knit.GetService("CommandPermissions"):checkPermissions(context.Executor, context.Group)
    local hasPermission = false
    if RunService:IsClient() then
        result:andThen(function(returned)
            hasPermission = returned
        end):await()
    else
        hasPermission = result
    end
    if hasPermission then return end
    return `You do not have permission to run the "{context.Name}" command. You must be a member of the "{context.Group}" group to run this command.`
end

function register(registry)
    registry:RegisterHook("BeforeRun", hook)
end

return register