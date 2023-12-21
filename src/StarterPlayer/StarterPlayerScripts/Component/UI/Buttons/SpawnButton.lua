local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local ClickButton = require(script.Parent.ClickButton)

local component = Component.new {
    Tag = "SpawnButton",
}

function component:Construct()
    if not self.Instance:HasTag(ClickButton.Tag) then
        self.Instance:AddTag(ClickButton.Tag)
    end
    ClickButton:WaitForInstance(self.Instance)
    :andThen(function(clickButton)
        self.objects = clickButton.objects
        self.events = clickButton.events
        self.team = self.objects.button.SpawnTeam.Value :: Team
    end)
    :await()
end

function component:Start()
    self.events.selected:Connect(function()
        self:select()
    end)
end

function component:select()
    Knit.GetService("Respawn"):respawn(self.team)
    :andThen(function()
        local menu = self.Instance:FindFirstAncestorOfClass("ScreenGui")
        if menu then
            menu:Destroy()
        end
    end)
end

return component