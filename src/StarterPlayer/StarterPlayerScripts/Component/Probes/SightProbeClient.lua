local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local component = Component.new {
    Tag = "SightProbe",
    Ancestors = { workspace }
}

function component:Construct()
    if not self.Instance:IsA("Attachment") then
        error(`SightProbe: {self.Instance:GetFullName()} is not an attachment`)
    end
    self.observed = false
end

function component:SteppedUpdate()
    local isInViewport = self:isInViewport()
    local isVisible = self:isVisible()
    if not isInViewport or not isVisible then
        self:tryUpdateState(false)
    else
        self:tryUpdateState(true)
    end
end

function component:isInViewport()
    local _, isInViewport = workspace.CurrentCamera:WorldToViewportPoint(self.Instance.WorldPosition)
    return isInViewport
end

function component:isVisible()
    local cameraPosition = workspace.CurrentCamera.CFrame.Position
    local result = workspace:Raycast(
        cameraPosition,
        self.Instance.WorldPosition - cameraPosition
    )
    -- If nothing is in the way, we must have reached the attachment.
    local isVisible = result == nil
    return isVisible
end

function component:tryUpdateState(to: boolean)
    if not self.observed and to then
        self.observed = true
        Knit.GetService("SightProbe"):addObserver(self.Instance)
    elseif self.observed and not to then
        self.observed = false
        Knit.GetService("SightProbe"):removeObserver(self.Instance)
    end
end

return component