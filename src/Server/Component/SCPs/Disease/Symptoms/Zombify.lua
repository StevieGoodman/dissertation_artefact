local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local AssetService

local component = Component.new {
    Tag = "Zombify",
    Ancestors = { workspace }
}

function component:Construct()
    if not self.Instance:IsA("Humanoid") then
        self.Instance:RemoveTag(self.Tag)
        error(`Zombify component can only be attached to Humanoid instances! Instance: {self.Instance}`)
    end
    self.oldHumanoidDesc = nil
    Knit.OnStart():await()
    AssetService = Knit.GetService("Asset")
end

function component:Start()
    self.oldHumanoidDesc = self.Instance:GetAppliedDescription() :: HumanoidDescription
    local description = AssetService:getAsset("SCP008HumanoidDescription") :: HumanoidDescription
    local currentDescription = self.Instance:GetAppliedDescription() :: HumanoidDescription
    local currentAccessories = currentDescription:GetAccessories(true)
    description:SetAccessories(currentAccessories, true)
    description.Shirt = currentDescription.Shirt
    description.Pants = currentDescription.Pants
    if description then
        self.Instance:ApplyDescription(description)
    end
end

function component:Stop()
    if self.oldHumanoidDesc then
        self.Instance:ApplyDescription(self.oldHumanoidDesc)
    end
end

return component