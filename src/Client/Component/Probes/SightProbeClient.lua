local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local PLAYER = Players.LocalPlayer

local component = Component.new {
    Tag = "SightProbe",
    Ancestors = { workspace }
}

function component:Construct()
    if not self.Instance:IsA("Attachment") then
        error(`SightProbe: {self.Instance:GetFullName()} is not an attachment`)
    end
    self.observed = false
    self.onlyCharactersObserve = self.Instance:HasTag("OnlyCharactersObserve") -- If only alive characters can observe probe
end

function component:SteppedUpdate()
    if not self:isInViewport() or not self:isVisible() or not self:canBeObserved() then
        self:tryUpdateState(false)
    else
        self:tryUpdateState(true)
    end
end

function component:canBeObserved()
    return not self.onlyCharactersObserve or (PLAYER.Character and PLAYER.Character.Humanoid.Health > 0)
end

function component:isInViewport()
    local _, isInViewport = workspace.CurrentCamera:WorldToViewportPoint(self.Instance.WorldPosition)
    return isInViewport
end

function component:isVisible()
    local cameraPosition = workspace.CurrentCamera.CFrame.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.CollisionGroup = "Sight"
    raycastParams:AddToFilter(self.Instance.Parent)
    if Players.LocalPlayer.Character then
        raycastParams:AddToFilter(Players.LocalPlayer.Character:GetDescendants())
    end
    local result = workspace:Raycast(
        cameraPosition,
        self.Instance.WorldPosition - cameraPosition,
        raycastParams
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