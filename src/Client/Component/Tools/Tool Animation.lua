local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local component = Component.new {
    Tag = "Tool Animation",
    Ancestors = { workspace }
}

function component:Construct()
    assert(self.Instance:IsA("Animation"), "ToolAnimation must be an Animation")
    self.Instance = self.Instance :: Animation
    self.character = self.Instance:FindFirstAncestorWhichIsA("Tool"):FindFirstAncestorWhichIsA("Model")
    assert(self.character, "Character not found!")
    self.humanoid = self.character:FindFirstChildWhichIsA("Humanoid")
    assert(self.humanoid, "Humanoid not found in character!")
    self.animator = self.humanoid:FindFirstChildWhichIsA("Animator")
    assert(self.animator, "Animator not found in humanoid!")
end

function component:Start()
    self.track = self.animator:LoadAnimation(self.Instance)
    self.track.Looped = true
    self.track:Play()
end

function component:Stop()
    self.track:Stop()
end

return component