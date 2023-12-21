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
    self.vfxController = Knit.GetController("VFX")
end

function controller:KnitStart()
    Observers.observeCharacter(function(_, character: Model)
        character:WaitForChild("Humanoid").Died:Connect(function()
            self:showDeathMenu()
        end)
    end)
end

function controller:showDeathMenu()
    self.assetService:getAsset("DeathMenu")
    :andThen(function(menu)
        if menu then
            menu.Parent = self.player.PlayerGui
        else
            error("Cannot find death menu. Please hold [M] to respawn.")
        end
    end)
    :catch(error)
end

return controller