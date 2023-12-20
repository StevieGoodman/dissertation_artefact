local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Observers = require(ReplicatedStorage.Packages.Observers)

local component = Component.new {
    Tag = "HealthBar",
    Ancestors = { Players.LocalPlayer.PlayerGui }
}

function component:Start()
    self.Instance:SetAttribute("Progress", 100)
    Observers.observeCharacter(function(_, character)
        local connection = character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            self.Instance:SetAttribute("Progress", character.Humanoid.Health / character.Humanoid.MaxHealth * 100)
        end)
        return function()
            connection:Disconnect()
        end
    end)
end

function component:UpdateProgress(newValue: number)
    self.Instance.Size = UDim2.new(newValue / 100, 0, 1, 0)
end

return component