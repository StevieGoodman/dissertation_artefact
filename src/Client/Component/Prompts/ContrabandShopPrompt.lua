local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local component = Component.new {
    Tag = "Contraband Shop Prompt",
    Ancestors = { workspace }
}

function component:Construct()
    self.Instance = self.Instance :: ProximityPrompt
    Knit.OnStart():await()
    self.menuController = Knit.GetController("Menu")
end

function component:Start()
    self.Instance.Triggered:Connect(function()
        self.menuController:show("Contraband Shop", false, true)
    end)
end

return component