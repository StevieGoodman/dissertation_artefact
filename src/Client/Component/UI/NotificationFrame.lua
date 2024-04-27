local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "NotificationFrame",
    Ancestors = { Players.LocalPlayer.PlayerGui },
}

function component:Construct()
    self._frame = self.Instance
    self._title = Waiter.get.descendant(self._frame, "NotificationTitle")
    self._content = Waiter.get.descendant(self._frame, "NotificationContent")
    assert(self._title, "No NotificationTitle found")
    assert(self._content, "No NotificationContent found")
    self._queue = {} :: { title: string, content: string }
end

function component:queue(notification)
    table.insert(self._queue, notification)
    if #self._queue ~= 1 then return end
    self:showNext()
end

function component:showNext()
    local notification = self._queue[1]
    if not notification then return end
    self._title.Text = notification.title
    self._content.Text = notification.content
    self._frame.Visible = true
    self._frame.GroupTransparency = 1
    self._frame.Stroke.Transparency = 1
    -- Fade in
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(self._frame, tweenInfo, { GroupTransparency = 0 })
    TweenService:Create(self._frame.Stroke, tweenInfo, { Transparency = 0 }):Play()
    tween:Play()
    tween.Completed:Wait()
    -- Show for a bit
    task.wait(#notification.content * 0.2)
    if self.Instance.Parent == nil then return end
    -- Fade out
    tween = TweenService:Create(self._frame, tweenInfo, { GroupTransparency = 1 })
    TweenService:Create(self._frame.Stroke, tweenInfo, { Transparency = 1 }):Play()
    tween:Play()
    tween.Completed:Wait()
    self._frame.Visible = false
    -- Wait a bit before showing the next notification
    task.wait(1)
    table.remove(self._queue, 1)
    self:showNext()
end

return component