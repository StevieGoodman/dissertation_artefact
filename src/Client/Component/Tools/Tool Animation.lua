local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local component = Component.new {
    Tag = "Tool Animation",
    Ancestors = { workspace }
}

function component:Construct()
    assert(self.Instance:IsA("Animation"), "ToolAnimation must be an Animation")
    self.Instance = self.Instance :: Animation
    
end

function component:Start()
    self.tool = self.Instance:FindFirstAncestorWhichIsA("Tool")
    assert(self.tool, "ToolAnimation must be a descendant of a tool")
    self:tryPlay()
    self.tool.AncestryChanged:Connect(function()
        self:tryPlay()
        self:tryStop()
    end)
end

function component:Stop()
    self:tryStop()
end

function component:tryPlay()
    local character = self.tool:FindFirstAncestorWhichIsA("Model")
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildWhichIsA("Animator")
    if not animator then return end
    self.track = animator:LoadAnimation(self.Instance)
    self.track.Looped = true
    self.track:Play()
end

function component:tryStop()
    if not self.track then return end
    local character = self.tool:FindFirstAncestorWhichIsA("Model")
    if not character then
        self.track:Stop()
        return
    else
        local player = Players:GetPlayerFromCharacter(character)
        if player then return end
        self.track:Stop()
        return
    end
end

return component