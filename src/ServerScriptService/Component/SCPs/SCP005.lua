local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local component = Component.new {
    Tag = "SCP005",
    Ancestors = { workspace, Players }
}

function component:Construct()
    self.spawn = self.Instance:GetPrimaryPartCFrame()
    self.parent = self.Instance.Parent
    self.assetService = Knit.GetService("Asset")
end

function component:Stop()
    local scp005 = self.assetService:getAsset("SCP005")
    scp005.Parent = self.parent
    scp005:SetPrimaryPartCFrame(self.spawn)
end

return component