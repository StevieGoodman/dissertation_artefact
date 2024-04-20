local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local Button = require(script.Parent.Button)

local ANIMATION_DURATION = script:GetAttribute("AnimationDuration") or 0.1

local component = Component.new {
    Tag = "SelectButton",
}

function component:Construct()
    if not self.Instance:HasTag(Button.Tag) then
        self.Instance:AddTag(Button.Tag)
    end
    Button:WaitForInstance(self.Instance)
    :andThen(function(button)
        self.button = button
        self.objects = self.button.objects
        self.events = self.button.events
        self.events.deselected = Signal.new()
        local children = self.button.objects.button.Parent:GetChildren()
        self.siblingButtons = TableUtil.Filter(children, function(child)
            return child:IsA("GuiButton") and child ~= self.objects.button
        end) :: {TextButton}
        self.isSelected = self.objects.button.BackgroundTransparency == 0
    end)
    :await()
end

function component:Start()
    self:registerEvents()
end

function component:registerEvents()
    self.objects.button.MouseEnter:Connect(function()
        if not self.isSelected then
            self:highlight()
        end
    end)
    self.objects.button.MouseLeave:Connect(function()
        if not self.isSelected then
            self:unhighlight()
        end
    end)
    self.objects.button.MouseButton1Click:Connect(function()
        if not self.isSelected then
            self:select()
        end
    end)
end

function component:setTransparency(transparency: number)
    TweenService:Create(
        self.objects.button,
        TweenInfo.new(ANIMATION_DURATION),
        {
            BackgroundTransparency = transparency,
            TextTransparency = transparency,
        }
    ):Play()
    TweenService:Create(
        self.objects.uiStroke,
        TweenInfo.new(ANIMATION_DURATION),
        { Transparency = transparency, }
    ):Play()
end

function component:highlight()
    self:setTransparency(0.25)
    self.events.highlighted:Fire()
end

function component:unhighlight()
    self:setTransparency(0.5)
    self.events.unhighlighted:Fire()
end

function component:select()
    self:deselectSiblings()
    self:setTransparency(0)
    self.isSelected = true
    self.events.selected:Fire()
end

function component:deselect()
    self:setTransparency(0.5)
    self.isSelected = false
    self.events.deselected:Fire()
end

function component:deselectSiblings()
    for _, button in self.siblingButtons do
        local otherButton = self:FromInstance(button)
        if otherButton and otherButton.isSelected then
            otherButton:deselect()
        end
    end
end

return component