local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local AssetService = Knit.GetService("Asset")

local SCP500 = Component.new {
    Tag = "SCP500",
    Ancestors = { workspace, Players },
    Extensions = {
        ShouldConstruct = function(self)
            local isTool = self.Instance:IsA("Tool")
            if not isTool then
                warn(`SCP500 component cannot be added to non-tool instance. Instance: ${self.Instance:GetFullName()}`)
            end
            return isTool
        end
    }
}

function SCP500:Construct()
    self.Instance = self.Instance :: Tool
    self.RespawnCFrame = self.Instance:GetPivot()
    self.RespawnParent = self.Instance.Parent
end

function SCP500:Start()
    self.Instance.Activated:Connect(function()
        self:Use()
    end)
end

function SCP500:Stop()
    local scp_500 = AssetService:getAsset("SCP500")
    scp_500:PivotTo(self.RespawnCFrame)
    scp_500.Parent = self.RespawnParent
end

function SCP500:Use()
    local player = Players:GetPlayerFromCharacter(self.Instance.Parent)
    if player == nil then return end
    local humanoid = self.Instance.Parent.Humanoid
    humanoid:RemoveTag("SCP008Infection")
end

return SCP500