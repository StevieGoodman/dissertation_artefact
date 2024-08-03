local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local controller = Knit.CreateController {
    Name = "PostProcessing",
}

function controller:setMenuBlur(instance: Instance, intensity: number)
    local blur = Instance.new("BlurEffect")
    blur.Parent = Lighting
    blur.Size = 0
    TweenService:Create(blur, TweenInfo.new(0.25), {Size = intensity}):Play()
    instance.Destroying:Connect(function()
        TweenService:Create(blur, TweenInfo.new(0.25), {Size = 0}):Play()
        blur:Destroy()
    end)
end

return controller