local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local component = Component.new {
    Tag = "SCP008",
    Ancestors = { workspace }
}

function component:Start()
    self.Instance.Touched:Connect(function(part)
        self:tryInfectHumanoid(part)
    end)
end

function component:tryInfectHumanoid(part: BasePart)
    local humanoid = self:getHumanoidFromPart(part)
    if not humanoid then
        return
    end
    humanoid:AddTag("SCP008Infection")
end

function component:getHumanoidFromPart(part: BasePart)
   return part.Parent:FindFirstChild("Humanoid")
end

return component