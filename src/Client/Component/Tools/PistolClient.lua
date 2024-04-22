local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local component = Component.new {
    Tag = "Pistol",
}

function component:Start()
    self.Instance.Activated:Connect(function()
        self:tryFire()
    end)
    self.Instance.Equipped:Connect(function()
        UserInputService.MouseIconEnabled = true
        print(UserInputService.MouseIconEnabled)
        ContextActionService:BindAction("Reload", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then
                self:reload()
            end
        end, false, Enum.KeyCode.R)
    end)
    self.Instance.Unequipped:Connect(function()
        UserInputService.MouseIconEnabled = false
        ContextActionService:UnbindAction("Reload")
    end)
end

function component:tryFire()
    if self.Instance:GetAttribute("Ammo") <= 0 then return end
    self:fire()
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
        ray.Direction * self.Instance:GetAttribute("MaxRange"),
        raycastParams
    )
    if raycastResult then
        return raycastResult.Position
    end
end

function component:reload()
    Knit.GetService("Gun"):reload()
end

return component