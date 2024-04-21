local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local service = Knit.CreateService {
    Name = "CharacterIK",
}

function service:KnitStart()
    self.characters = {}
    Observers.observeCharacter(function(...)
        self:setUp(...)
    end)
end

function service:setUp(player: Player, character: Model)
    self.characters[player] = {}
    local ikInstances = self.characters[player]
    ikInstances.headIKTarget = Instance.new("Attachment")
    ikInstances.headIKTarget.Parent = character.HumanoidRootPart
    ikInstances.headIKTarget.CFrame = CFrame.new(0, 1.5, 1)
    ikInstances.headIKControl = Instance.new("IKControl")
    ikInstances.headIKControl.Parent = character.Humanoid
    ikInstances.headIKControl.EndEffector = character.Head
    ikInstances.headIKControl.ChainRoot = character.LowerTorso
    ikInstances.headIKControl.Target = ikInstances.headIKTarget
    ikInstances.headIKControl.Type = Enum.IKControlType.LookAt
end

function service.Client:updateFacingDirection(player: Player, direction: Vector3)
    if not player.Character or not self.Server.characters[player] then return end
    local ikInstances = self.Server.characters[player]
    ikInstances.headIKTarget.CFrame = CFrame.new(0, 1.5, 0)
    ikInstances.headIKControl.Weight = player.Character.HumanoidRootPart.CFrame.LookVector:Dot(direction) + 1
    direction = ikInstances.headIKTarget.WorldCFrame:VectorToObjectSpace(direction)
    ikInstances.headIKTarget.CFrame += direction * 5
end

return service