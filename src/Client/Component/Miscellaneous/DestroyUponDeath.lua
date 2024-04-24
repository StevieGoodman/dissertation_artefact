local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Observers = require(ReplicatedStorage.Packages.Observers)

local PLAYER = game:GetService("Players").LocalPlayer

local component = Component.new {
    Tag = "Destroy Upon Death",
}

function component:Start()
    Observers.observeCharacter(function(player: Player, character: Model)
        if player ~= PLAYER then return end
        character:WaitForChild("Humanoid", 1).Died:Connect(function()
            self.Instance:Destroy()
        end)
    end)
end

return component