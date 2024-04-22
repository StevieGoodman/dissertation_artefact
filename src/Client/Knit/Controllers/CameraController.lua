local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local PLAYER = game.Players.LocalPlayer

local controller = Knit.CreateController {
    Name = "Camera",
}

controller.zoomedInFov = 25
controller.cameraOffset = Vector3.new(2.5, 1.5, 5)
controller.tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

controller.CameraType = {
    CursorUnlocked = "Unlocked",
    CharacterUnlocked = "CharacterUnlocked",
    CharacterLocked = "CharacterLocked",
}

function controller:KnitInit()
    self.camera = workspace.CurrentCamera
    controller.zoomedOutFov = self.camera.FieldOfView
    self.cursorController = Knit.GetController("Cursor")
end

function controller:KnitStart()
    Observers.observeCharacter(function(player, character)
        if player ~= Players.LocalPlayer then return end
        character:WaitForChild("Humanoid", 5)
        self:setCameraType(self.CameraType.CharacterUnlocked)
        self.cursorController:setCursorIcon(self.cursorController.CursorIcon.Hidden)
        ContextActionService:BindAction(
            "Zoom",
            function(_, state)
                if state == Enum.UserInputState.Begin then
                    self:zoomTo(self.zoomedInFov)
                elseif state == Enum.UserInputState.End then
                    self:zoomTo(self.zoomedOutFov)
                end
            end,
            false,
            Enum.UserInputType.MouseButton2
        )
        character.Humanoid.Died:Connect(function()
            ContextActionService:UnbindAction("Zoom")
            self:setCameraType(self.CameraType.CursorUnlocked)
        end)
        return function()
            ContextActionService:UnbindAction("Zoom")
            self:setCameraType(self.CameraType.CursorUnlocked)
        end
    end)
end

function controller:setCameraType(cameraType: string)
    if cameraType == self.CameraType.CursorUnlocked then
        self.cursorController:setMouseBehaviour(Enum.MouseBehavior.Default)
        RunService:UnbindFromRenderStep("ApplyCameraOffset")
        RunService:UnbindFromRenderStep("ApplyCharacterRotation")
    else
        self.cursorController:setMouseBehaviour(Enum.MouseBehavior.LockCenter)
        RunService:BindToRenderStep(
            "ApplyCameraOffset",
            Enum.RenderPriority.Camera.Value,
            function()
                self:applyCameraOffset()
            end
        )
        if cameraType == self.CameraType.CharacterLocked then
            RunService:BindToRenderStep(
                "ApplyCharacterRotation",
                Enum.RenderPriority.Camera.Value,
                function()
                    self:applyCharacterRotation()
                end
            )
        else
            RunService:UnbindFromRenderStep("ApplyCharacterRotation")
        end
    end
end

function controller:applyCameraOffset()
    local camera = workspace.CurrentCamera :: Camera
    local character = PLAYER.Character
    if not character then return end
    local targetCFrame =
        CFrame.new(character.HumanoidRootPart.Position)
        * camera.CFrame.Rotation
        * CFrame.new(self.cameraOffset)
    -- Add collision detection with raycasts
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.CollisionGroup = "CameraRaycast"
    raycastParams.FilterDescendantsInstances = {character}
    local depthRaycastResult = workspace:Raycast(
        character.Head.Position,
        targetCFrame.Position - character.Head.Position,
        raycastParams
    )
    if depthRaycastResult then
        targetCFrame = CFrame.new(depthRaycastResult.Position + depthRaycastResult.Normal * 0.2) * targetCFrame.Rotation
    end
    camera.CFrame = targetCFrame
end

function controller:applyCharacterRotation()
    local character = PLAYER.Character
    if not character then return end
    local direction = Vector3.new(self.camera.CFrame.LookVector.X, 0, self.camera.CFrame.LookVector.Z)
    local newCFrame = CFrame.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + direction)
    character:PivotTo(newCFrame)
end

function controller:zoomTo(fov: number)
    TweenService:Create(self.camera, self.tweenInfo, {FieldOfView = fov}):Play()
end

return controller