local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local component = Component.new {
    Tag = "Door",
    Ancestors = { workspace }
}

function component:Start()
    self.Instance.Touched:Connect(function(part)
        self:tryOpenDoor(part)
    end)
end

function component:tryOpenDoor(part: BasePart)
    local player = Players:GetPlayerFromCharacter(part.Parent)
    if player and player.Team.Name ~= "Class-D Personnel" then
        self.Instance.CanCollide = false
        self.Instance.CanTouch = false
        task.wait(script:GetAttribute("OpenTime") or 3)
        self.Instance.CanCollide = true
        self.Instance.CanTouch = true
    end
end

return component