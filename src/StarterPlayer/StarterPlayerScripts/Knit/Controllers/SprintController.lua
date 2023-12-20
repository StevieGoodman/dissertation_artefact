local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local controller = Knit.CreateController {
    Name = "Sprint",
}

function controller:KnitInit()
    self.service = Knit.GetService("Sprint")
end

function controller:KnitStart()
    Observers.observeCharacter(function()
        ContextActionService:BindAction(
            "Sprint",
            function(_, _, inputObject: InputObject)
                self:sprint(inputObject)
            end,
            true,
            Enum.KeyCode.LeftShift
        )
        return function()
            ContextActionService:UnbindAction("Sprint")
        end
    end)
end

function controller:sprint(inputObject: InputObject)
    if inputObject.UserInputState == Enum.UserInputState.Begin then
        self.service:sprint()
    elseif inputObject.UserInputState == Enum.UserInputState.End then
        self.service:walk()
    end
end

return controller