local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

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
    if not player then
        return
    end
    local hasSCP005 = Waiter.get.child(player.Character, { tag = "SCP005" })
    if player.Team.Name == "Class-D Personnel" and not hasSCP005 then
        return
    end
    self.Instance.CanCollide = false
    self.Instance.CanTouch = false
    task.wait(script:GetAttribute("OpenTime") or 3)
    self.Instance.CanCollide = true
    self.Instance.CanTouch = true
end

return component