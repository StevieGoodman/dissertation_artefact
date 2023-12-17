local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local SelectButtonComponent = require(script.Parent.SelectButtonComponent)

local extensions = {}

function extensions.ShouldConstruct(component)
    return component.Instance:HasTag("SelectButton")
end

local component = Component.new {
    Tag = "MenuToggleButton",
    Extensions = { extensions }
}

function component:Construct()
end

function component:Start()
    self:registerSignals()
end

function component:registerSignals()
    local selectButtonComponent = self:GetComponent(SelectButtonComponent)
    selectButtonComponent.selected:Connect(function(selectButton)
        if selectButton.Instance == self.Instance then
            self:select(selectButton)
        end
    end)
    selectButtonComponent.deselected:Connect(function(selectButton)
        if selectButton.Instance == self.Instance then
            self:deselect(selectButton)
        end
    end)
end

function component:select(selectButton)
    selectButton.objects.menuFrame.Visible = true
end

function component:deselect(selectButton)
    selectButton.objects.menuFrame.Visible = false
end

return component