local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local component = Component.new {
    Tag = "Blur",
    Descendants = {
        Players.LocalPlayer.PlayerGui
    }
}

function component:Construct()
    local intensity = self.Instance:GetAttribute("Intensity") or 16
    Knit.OnStart():await()
    Knit.GetController("PostProcessing"):setMenuBlur(self.Instance, intensity)
end

return component