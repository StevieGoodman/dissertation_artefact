local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local controller = Knit.CreateController {
    Name = "PostProcessing",
}

function controller:KnitInit()
    self.blurEffect = Waiter.get.child(Lighting, "Blur Effect")
end

function controller:enableMenuBlur(screenGui: ScreenGui, intensity: number)
    self.blurEffect.Enabled = true
    self.blurEffect.Size = intensity
    screenGui.Destroying:Connect(function()
        self.blurEffect.Enabled = false
    end)
end

return controller