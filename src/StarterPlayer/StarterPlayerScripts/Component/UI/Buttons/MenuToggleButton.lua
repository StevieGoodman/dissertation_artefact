local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local SelectButton = require(script.Parent.SelectButton)

local component = Component.new {
    Tag = "MenuToggleButton",
}

function component:Construct()
    if not self.Instance:HasTag(SelectButton.Tag) then
        self.Instance:AddTag(SelectButton.Tag)
    end
    SelectButton:WaitForInstance(self.Instance)
    :andThen(function(selectButton)
        self.button = selectButton.button
        self.selectButton = selectButton
        self.objects = self.selectButton.objects
        self.events = self.selectButton.events
    end)
    :await()
end

function component:Start()
    self.selectButton = self:GetComponent(SelectButton)
    self:registerSignals()
end

function component:registerSignals()
    self.events.selected:Connect(function()
        self:select()
    end)
    self.events.deselected:Connect(function()
        self:deselect()
    end)
end

function component:select()
    self.objects.menuFrame.Visible = true
end

function component:deselect()
    self.objects.menuFrame.Visible = false
end

return component