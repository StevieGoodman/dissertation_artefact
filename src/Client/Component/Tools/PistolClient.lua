local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local PLAYER = Players.LocalPlayer

local component = Component.new {
    Tag = "Pistol",
}

function component:Construct()
    self.cursorController = Knit.GetController("Cursor")
    self.cameraController = Knit.GetController("Camera")
    Knit.OnStart():await()
end

function component:Start()
    if not self.Instance:IsDescendantOf(PLAYER)
        and not self.Instance:IsDescendantOf(PLAYER.Character) 
        then return end
    self.Instance.Activated:Connect(function()
        self:tryFire()
    end)
    self.Instance.Equipped:Connect(function()
        self.cursorController:setCursorIcon(self.cursorController.CursorIcon.Simple)
        self.cameraController:setCameraType(self.cameraController.CameraType.CharacterLocked)
        ContextActionService:BindAction("Reload", function(_, inputState, _)
            if inputState == Enum.UserInputState.Begin then
                self:reload()
            end
        end, false, Enum.KeyCode.R)
    end)
    self.Instance.Unequipped:Connect(function()
        self.cameraController:setCameraType(self.cameraController.CameraType.CharacterUnlocked)
        local cursorIcon =
            if Players.LocalPlayer.Character.Humanoid.Health <= 0
            then self.cursorController.CursorIcon.Default
            else self.cursorController.CursorIcon.Hidden
        self.cursorController:setCursorIcon(cursorIcon)
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