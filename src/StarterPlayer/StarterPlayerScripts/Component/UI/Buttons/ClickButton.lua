local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)

local Button = require(script.Parent.Button)

local ANIMATION_DURATION = script:GetAttribute("AnimationDuration") or 0.1

local component = Component.new {
    Tag = "ClickButton",
}

function component:Construct()
    if not self.Instance:HasTag(Button.Tag) then
        self.Instance:AddTag(Button.Tag)
    end
    Button:WaitForInstance(self.Instance)
    :andThen(function(button)
        self.objects = button.objects
        self.events = button.events
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
    self:setTransparency(0)
    self.events.selected:Fire()
    local transparency = 0.25
    local connection = self.objects.button.MouseLeave:Connect(function()
        transparency = 0.5
    end)
    task.wait(ANIMATION_DURATION)
    connection:Disconnect()
    self:setTransparency(transparency)
end

return component