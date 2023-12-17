local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local ANIMATION_DURATION = script:GetAttribute("AnimationDuration") or 0.1

local component = Component.new {
    Tag = "SelectButton",
}

function component:Construct()
    self:collectObjects()
    self.isSelected = self.objects.button.BackgroundTransparency == 0
    self.highlighted = Signal.new()
    self.unhighlighted = Signal.new()
    self.selected = Signal.new()
    self.deselected = Signal.new()
end

function component:Start()
    self:registerEvents()
end

function component:collectObjects()
    self.objects = {
        button = self.Instance :: TextButton,
        uiStroke = self.Instance.Stroke :: UIStroke,
        menuFrame = self.Instance.MenuFrame.Value :: Frame,
    }
    local children = self.objects.button.Parent:GetChildren()
    self.siblingButtons = TableUtil.Filter(children, function(child)
        return child:IsA("GuiButton") and child ~= self.objects.button
    end) :: {TextButton}
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
    self.highlighted:Fire()
end

function component:unhighlight()
    self:setTransparency(0.5)
    self.unhighlighted:Fire()
end

function component:select()
    self:deselectSiblings()
    self:setTransparency(0)
    self.isSelected = true
    self.selected:Fire()
end

function component:deselect()
    self:setTransparency(0.5)
    self.isSelected = false
    self.deselected:Fire()
end

function component:deselectSiblings()
    for _, button in self.siblingButtons do
        local comp = self:FromInstance(button)
        if comp and comp.isSelected then
            comp:deselect()
        end
    end
end

return component