local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Timer = require(ReplicatedStorage.Packages.Timer)

local component = Component.new {
    Tag = "SCP008Source",
    Ancestors = { workspace }
}

component.INFECTION_INTERVAL = 0.5

function component:Construct()
    self.infectionRange = self.Instance:GetAttribute("InfectionRange") or 8
    self.infectionMtb = self.Instance:GetAttribute("InfectionMtb") or 20
    self.checkedHumanoids = {}
end

function component:Start()
    self.timer = Timer.Simple(
        self.INFECTION_INTERVAL,
        function()
            self:tryInfectNearby()
            self.checkedHumanoids = {}
        end
    )
end

function component:Stop()
    self.timer:Disconnect()
end

function component:tryInfectNearby()
    local nearbyParts = workspace:GetPartBoundsInRadius(self:getPosition(), self.infectionRange)
    for _, part in nearbyParts do
        self:tryInfectHumanoid(part)
    end
end

function component:tryInfectHumanoid(part: BasePart)
    local humanoid = self:getHumanoidFromPart(part)
    if not humanoid then return end
    if humanoid:HasTag("SCP008Infection") then return end -- Prevents characters from being infected multiple times
    if table.find(self.checkedHumanoids, humanoid) then return end -- Prevents characters from being infected multiple times
    table.insert(self.checkedHumanoids, humanoid)
    if not self:rollInfection() then return end
    humanoid:AddTag("SCP008Infection")
end

function component:rollInfection()
    local threshold = self.INFECTION_INTERVAL / self.infectionMtb
    local roll = Random.new():NextNumber(0, 1)
    return roll < threshold
end

function component:getHumanoidFromPart(part: BasePart)
   return part.Parent:FindFirstChild("Humanoid")
end

function component:getPosition()
    return if self.Instance:IsA("PVInstance") then
        self.Instance:GetPivot().Position
    elseif self.Instance:IsA("Humanoid") then
        self.Instance.Parent:GetPivot().Position
    else nil
end

return component