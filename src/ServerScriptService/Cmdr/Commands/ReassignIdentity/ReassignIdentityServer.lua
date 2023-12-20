local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.OnStart():await()

local IdentityService = Knit.GetService("Identity")

return function(_, target: Player, identity: string?)
    local success, result = pcall(function()
        return IdentityService:assignIdentity(target, identity)
    end)
    if success then
        return `Reassigned identity of {target}! Their new identity is "{result}".`
    else
        return `Failed to reassign the identity for {target}! {result}`
    end
end