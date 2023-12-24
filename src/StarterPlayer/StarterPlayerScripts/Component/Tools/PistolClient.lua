local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local component = Component.new {
    Tag = "Pistol",
}

function component:Construct()
    self.pistol = self.Instance :: Tool
    self.maxRange = self.pistol:GetAttribute("MaxRange") or 256
end

function component:Start()
    self.pistol.Activated:Connect(function()
        self:fire()
    end)
end

function component:fire()
    local mousePosition = self:getMousePosition()
    if mousePosition then
        Knit.GetService("Gun"):fire(mousePosition)
    end
end

function component:getMousePosition()
    local position2d = UserInputService:GetMouseLocation()
    local ray = workspace.CurrentCamera:ViewportPointToRay(position2d.X, position2d.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { Players.LocalPlayer.Character }
    local raycastResult = workspace:Raycast(
        ray.Origin,
        ray.Direction * self.maxRange,
        raycastParams
    )
    if raycastResult then
        return raycastResult.Position
    end
end

return component