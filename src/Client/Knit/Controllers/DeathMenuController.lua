local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local controller = Knit.CreateController {
    Name = "DeathMenu"
}

function controller:KnitInit()
    self.player = Players.LocalPlayer
    self.assetService = Knit.GetService("Asset")
end

function controller:KnitStart()
    Observers.observeCharacter(function(_, character: Model)
        if character ~= self.player.Character then return end
        character:WaitForChild("Humanoid").Died:Connect(function()
            Knit.GetController("Menu"):show("Death Menu")
        end)
    end)
end

return controller