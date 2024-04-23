local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local controller = Knit.CreateController {
    Name = "PostProcessing",
}

function controller:setMenuBlur(instance: Instance, intensity: number)
    local blur = Instance.new("BlurEffect")
    blur.Parent = Lighting
    blur.Size = intensity
    instance.Destroying:Connect(function()
        blur:Destroy()
    end)
end

return controller