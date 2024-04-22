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

function controller:KnitStart()
    self:setCursorIcon(self.CursorIcon.Default)
end

function controller:setMouseBehaviour(mouseBehaviour: Enum.MouseBehavior)
    RunService:UnbindFromRenderStep("ApplyCursorBehaviour")
    RunService:BindToRenderStep(
        "ApplyCursorBehaviour",
        Enum.RenderPriority.Input.Value,
        function()
            UserInputService.MouseBehavior = mouseBehaviour
        end
    )
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