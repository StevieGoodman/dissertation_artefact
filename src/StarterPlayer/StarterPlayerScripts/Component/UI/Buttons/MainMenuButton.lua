local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local ClickButton = require(script.Parent.ClickButton)

local component = Component.new {
    Tag = "MainMenuButton",
}

function component:Construct()
    self.mainMenuController = Knit.GetController("MainMenu")
    if not self.Instance:HasTag(ClickButton.Tag) then
        self.Instance:AddTag(ClickButton.Tag)
    end
    ClickButton:WaitForInstance(self.Instance)
    :andThen(function(button)
        self.objects = button.objects
        self.events = button.events
    end)
    :await()
end

function component:Start()
    self.events.selected:Connect(function()
        self:select()
    end)
end

function component:select()
    self.mainMenuController:showMainMenu()
    local menu = self.Instance:FindFirstAncestorOfClass("ScreenGui")
    if menu then
        menu:Destroy()
    end
end

return component