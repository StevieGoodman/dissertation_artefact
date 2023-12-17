local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)

local SelectButtonComponent = require(script.Parent.SelectButtonComponent)

local ANIMATION_DURATION = script:GetAttribute("AnimationDuration") or 0.1

local extensions = {}

function extensions.ShouldConstruct(component)
    return component.Instance:HasTag("SelectButton")
end

local component = Component.new {
    Tag = "InsetButton",
    extensions = { extensions }
}

function component:Start()
    self.selectButton = self:GetComponent(SelectButtonComponent)
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
    self:setInset(32)
end

function component:deselect()
    self:setInset(0)
end

function component:setInset(inset)
    local button = self.selectButton.objects.button
    local newPos = UDim2.fromOffset(inset, button.Position.Y.Offset)
    TweenService:Create(
        button,
        TweenInfo.new(ANIMATION_DURATION),
        { Position = newPos }
    ):Play()
end


return component