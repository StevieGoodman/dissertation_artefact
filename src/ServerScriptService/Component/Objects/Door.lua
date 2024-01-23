local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Component = require(ReplicatedStorage.Packages.Component)
local WaiterV5 = require(ReplicatedStorage.Packages.WaiterV5)

local InteractableObjectComponent = require(script.Parent.InteractableObject)

local MOVING_DURATION = script:GetAttribute("MovingDuration") or 1.4
local OPEN_DURATION = script:GetAttribute("OpenDuration") or 5

local component = Component.new {
    Tag = "Door",
    Ancestors = { workspace }
}

function component:Construct()
    self.interactableObjectComponent = InteractableObjectComponent:FromInstance(self.Instance)
    self.attachment = WaiterV5.get.child(self.Instance, "DoorAttachment") :: Attachment
    self.sound = WaiterV5.get.child(self.Instance, "DoorSound") :: Sound
    self.busy = false
end

function component:Start()
    self.interactableObjectComponent.interacted:Connect(function(_)
        self:tryOpenDoor()
    end)
end

function component:tryOpenDoor()
    if self.busy then return end
    self:openDoor()
end

function component:openDoor()
    self.busy = true
    self.sound:Play()
    local closedCFrame = self.Instance.CFrame
    local openedCFrame = self.attachment.WorldCFrame
    local tweenInfo = TweenInfo.new(
        MOVING_DURATION,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut
    )
    -- Open
    local tween = TweenService:Create(
        self.Instance,
        tweenInfo,
        { CFrame = openedCFrame }
    )
    tween:Play()
    tween.Completed:Wait()
    task.wait(OPEN_DURATION)
    -- Close
    self.sound:Play()
    tween = TweenService:Create(
        self.Instance,
        tweenInfo,
        { CFrame = closedCFrame }
    )
    tween:Play()
    tween.Completed:Wait()
    self.busy = false
end

return component