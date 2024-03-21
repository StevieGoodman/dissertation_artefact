local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local DAMAGE_RATE = 10
local PROGRESSION_RATE_MIN = 0.5
local PROGRESSION_RATE_MAX = 1.5

local component = Component.new {
    Tag = "SCP008Infection",
    Ancestors = { workspace }
}

function component:Construct()
    Knit.OnStart():await()
    self.assetService = Knit.GetService("Asset")
    self.progression = 0
    self.progressionRate = math.random(PROGRESSION_RATE_MIN * 10, PROGRESSION_RATE_MAX * 10) / 10
    self.contagious = false
    self.humanoidRoot = self.Instance
    self.humanoid = self.Instance.Parent.Humanoid :: Humanoid
end

function component:Start()
    print(`{self.Instance.Parent.Name} has been infected by SCP-008!`)
end

function component:SteppedUpdate(dt)
    print(self.progression, self.progressionRate)
    self.progression = self.progression + (self.progressionRate * dt)
    self.progression = math.clamp(self.progression, 0, 100)
    if self.progression == 100 then
        self.humanoid:TakeDamage(DAMAGE_RATE * dt)
    end
    if self.progression >= 30 and not self.contagious then
        self:makeContagious()
    end
end

function component:makeContagious()
    self.contagious = true
    local description = self.assetService:getAsset("SCP008HumanoidDescription") :: HumanoidDescription
    local currentDescription = self.humanoid:GetAppliedDescription()
    local currentAccessories = currentDescription:GetAccessories(true)
    description:SetAccessories(currentAccessories, true)
    description.Shirt = currentDescription.Shirt
    description.Pants = currentDescription.Pants
    if description then
        self.humanoid:ApplyDescription(description)
    end
    self.humanoidRoot:AddTag("SCP008")
end


return component