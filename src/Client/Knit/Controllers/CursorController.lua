local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local controller = Knit.CreateController {
    Name = "Cursor",
}

controller.CursorIcon = {
    Default = UserInputService.MouseIcon,
    Simple = "rbxassetid://17253015288",
    Hidden = nil,
}

function controller:KnitInit()
    self.mouseBehaviour = Enum.MouseBehavior.Default
end

function controller:KnitStart()
    self:setCursorIcon(self.CursorIcon.Default)
    RunService:BindToRenderStep(
        "ApplyCursorBehaviour",
        Enum.RenderPriority.Camera.Value,
        function()
            self:_applyCursorBehaviour()
        end
    )
end

function controller:_applyCursorBehaviour()
    UserInputService.MouseBehavior = self.mouseBehaviour
end

function controller:setCursorIcon(cursorIcon: string?)
    if cursorIcon == self.CursorIcon.Hidden then
        UserInputService.MouseIconEnabled = false
    else
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseIcon = cursorIcon
    end
end

return controller