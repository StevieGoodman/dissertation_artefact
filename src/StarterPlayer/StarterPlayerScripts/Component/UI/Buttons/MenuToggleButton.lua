local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local SelectButton = require(script.Parent.SelectButtonComponent)

local extensions = {}

function extensions.ShouldConstruct(component)
    return component.Instance:HasTag("SelectButton")
end

local component = Component.new {
    Tag = "MenuToggleButton",
    Extensions = { extensions }
}

function component:Start()
    self.selectButton = self:GetComponent(SelectButton)
    self:registerSignals()
end

function component:registerSignals()
    self.selectButton.selected:Connect(function()
        self:select()
    end)
    self.selectButton.deselected:Connect(function()
        self:deselect()
    end)
end

function component:select()
    self.selectButton.objects.menuFrame.Visible = true
end

function component:deselect()
    self.selectButton.objects.menuFrame.Visible = false
end

return component