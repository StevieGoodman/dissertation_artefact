local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local component = Component.new {
    Tag = "Blur",
}

function component:Construct()
    self.size = self.Instance:GetAttribute("Size") or 16
    self.vfxController = Knit.GetController("VFX")
end

function component:Start()
    self.vfxController:setBlur(self.size)
end

function component:Stop()
    self.vfxController:setBlur(0)
end

return component