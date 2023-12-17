local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Component = require(ReplicatedStorage.Packages.Component)

local ANIMATION_DURATION = 0.25

local component = Component.new {
    Tag = "SelectButton",
}

function component:Construct()
    self:collectObjects()
    self.selected = self:isSelected()
end

function component:Start()
    self.objects.button.MouseEnter:Connect(function()
        if not self.selected then
            self:highlight()
        end
    end)
    self.objects.button.MouseLeave:Connect(function()
        if not self.selected then
            self:deselect()
        end
    end)
    self.objects.button.MouseButton1Click:Connect(function()
        if self.selected then
            self:deselect()
        else
            self:select()
        end
    end)
end

function component:collectObjects()
    self.objects = {
        button = self.Instance :: TextButton,
        uiStroke = self.Instance.Stroke :: UIStroke,
        sidebarFrame = self.Instance.MenuFrame.Value :: Frame,
    }
    local children = self.objects.button.Parent:GetChildren()
    self.siblingButtons = TableUtil.Filter(children, function(child)
        return child:IsA("GuiButton") and child ~= self.objects.button
    end) :: {TextButton}
end

function component:isSelected()
    return self.objects.button.BackgroundTransparency == 0
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
end

function component:select()
    self:deselectSiblings()
    self.selected = true
    self:setTransparency(0)
end

function component:deselect()
    self.selected = false
    self:setTransparency(0.5)
end

function component:deselectSiblings()
    for _, button in self.siblingButtons do
        local comp = self:FromInstance(button)
        if comp then
            comp:deselect()
        end
    end
end

return component