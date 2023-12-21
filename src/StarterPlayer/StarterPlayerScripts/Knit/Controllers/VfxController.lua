local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local controller = Knit.CreateController {
    Name = "VFX",
}

function controller:KnitInit()
    self.blur = Lighting.Blur :: BlurEffect
end

function controller:setBlur(value: number)
    self.blur.Size = value
end

return controller