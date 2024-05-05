local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local service = Knit.CreateService {
    Name = "Ragdoll",
}

function service:KnitStart()
    Observers.observeCharacter(function(_, character: Model)
        local humanoid = character:WaitForChild("Humanoid", 1) :: Humanoid
        assert(humanoid, "Character must have a Humanoid!")
        humanoid.BreakJointsOnDeath = false
    end)
end

return service