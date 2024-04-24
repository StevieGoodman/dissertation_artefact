local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)


local controller = Knit.CreateController {
    Name = "Input",
}

function controller:KnitInit()
    self.disabledInputNames = {}
end

function controller:isInputDisabled()
    return #self.disabledInputNames > 0
end

function controller:enableInput(name)
    table.remove(self.disabledInputNames, table.find(self.disabledInputNames, name))
    self:_updateInput()
end

function controller:disableInput(name)
    table.insert(self.disabledInputNames, name)
    self:_updateInput()
end

function controller:_updateInput()
    if self:isInputDisabled() then
        ContextActionService:BindAction(
            "Disable Input",
            function() return Enum.ContextActionResult.Sink end,
            false,
            Enum.UserInputType.MouseButton2,
            unpack(Enum.PlayerActions:GetEnumItems())
        )
    else
        ContextActionService:UnbindAction("Disable Input")
    end
end

return controller