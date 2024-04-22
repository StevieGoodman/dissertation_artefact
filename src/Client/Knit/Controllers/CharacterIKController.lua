local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local PLAYER = game.Players.LocalPlayer

local controller = Knit.CreateController {
    Name = "CharacterIK",
}

function controller:KnitInit()
    self.characterIKService = Knit.GetService("CharacterIK")
end

function controller:KnitStart()
    Observers.observeCharacter(function(_, character)
        self:lockCursor(character)
        RunService.Heartbeat:Connect(function()
            self:updateFacingDirection()
        end)
        character.Humanoid.Died:Connect(function()
            self:unlockCursor()
        end)
        return function()
            self:unlockCursor()
        end
    end)
end

function controller:lockCursor(character)
    character.Humanoid.CameraOffset = Vector3.new(2, 1.5, 5)
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false
    RunService:BindToRenderStep(
        "AdjustCameraPosition",
        Enum.RenderPriority.Camera.Value,
        function()
            self:adjustCameraPosition()
        end
    )
end

function controller:unlockCursor()
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    RunService:UnbindFromRenderStep("AdjustCameraPosition")
end

function controller:adjustCameraPosition()
    local camera = workspace.CurrentCamera
    local character = PLAYER.Character
    if not character then return end
    local cameraOffset = character.Humanoid.CameraOffset
    local targetCFrame = CFrame.new(character.HumanoidRootPart.Position) * camera.CFrame.Rotation * CFrame.new(cameraOffset)
    -- Add collision detection with raycasts
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
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

function controller:updateFacingDirection()
    local camera = workspace.CurrentCamera
    local direction = camera.CFrame.LookVector
    self.characterIKService:updateFacingDirection(direction)
end

return controller