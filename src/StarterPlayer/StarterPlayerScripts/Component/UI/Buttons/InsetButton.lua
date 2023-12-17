local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)

local SelectButton = require(script.Parent.SelectButton)

local ANIMATION_DURATION = script:GetAttribute("AnimationDuration") or 0.1

local component = Component.new {
    Tag = "InsetButton",
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