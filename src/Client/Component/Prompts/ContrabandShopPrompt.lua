local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local PLAYER = Players.LocalPlayer

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
        self.Instance.Enabled = false
        self.menuController:show("Contraband Shop", false, true)
        local menu = PLAYER.PlayerGui:WaitForChild("Contraband Shop", 10) :: ScreenGui
        if menu then
            menu.Destroying:Wait()
        end
        self.Instance.Enabled = true
    end)
end

return component