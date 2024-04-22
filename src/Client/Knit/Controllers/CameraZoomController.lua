local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local controller = Knit.CreateController {
    Name = "CameraZoom",
}

controller.zoomedInFov = 25
controller.tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

function controller:KnitInit()
    self.camera = workspace.CurrentCamera
    controller.zoomedOutFov = self.camera.FieldOfView
end

function controller:KnitStart()
    Observers.observeCharacter(function(_, character)
        ContextActionService:BindAction(
            "ZoomIn",
            function(_, state)
                if state == Enum.UserInputState.Begin then
                    self:zoomIn()
                elseif state == Enum.UserInputState.End then
                    self:zoomOut()
                end
            end,
            false,
            Enum.UserInputType.MouseButton2
        )
        character.Humanoid.Died:Connect(function()
            ContextActionService:UnbindAction("ZoomIn")
        end)
        return function()
            ContextActionService:UnbindAction("ZoomIn")
        end
    end)
end

function controller:zoomIn()
    TweenService:Create(self.camera, self.tweenInfo, {FieldOfView = controller.zoomedInFov}):Play()
end

function controller:zoomOut()
    TweenService:Create(self.camera, self.tweenInfo, {FieldOfView = controller.zoomedOutFov}):Play()
end

return controller