local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local controller = Knit.CreateController {
    Name = "CharacterIK",
}

function controller:KnitInit()
    self.characterIKService = Knit.GetService("CharacterIK")
    self.cursorController = Knit.GetController("Cursor")
    self.cameraController = Knit.GetController("Camera")
end

function controller:KnitStart()
    Observers.observeCharacter(function(_, character)
        character:WaitForChild("Humanoid", 5)
        RunService:BindToRenderStep(
            "UpdateFacingDirection",
            Enum.RenderPriority.Camera.Value,
            function()
                self:updateFacingDirection()
            end
        )
        character.Humanoid.Died:Connect(function()
            UserInputService.MouseIconEnabled = true
            RunService:UnbindFromRenderStep("UpdateFacingDirection")
        end)
        return function()
            UserInputService.MouseIconEnabled = true
            RunService:UnbindFromRenderStep("UpdateFacingDirection")
        end
    end)
end

function controller:updateFacingDirection()
    local camera = workspace.CurrentCamera
    local direction = camera.CFrame.LookVector
    self.characterIKService:updateFacingDirection(direction)
end

return controller