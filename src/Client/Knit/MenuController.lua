local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local controller = Knit.CreateController {
    Name = "Menu"
}

function controller:KnitInit()
    self.assetService = Knit.GetService("Asset")
    self.respawnService = Knit.GetService("Respawn")
    self.player = Players.LocalPlayer
end

function controller:show(name: string)
    self.assetService:getAsset(name)
    :andThen(function(menu)
        if menu then
            menu.Parent = self.player.PlayerGui
        else
            self.player:Kick([[Unable to get menu. 
                Either the game is broken, or your internet connection is poor.
                Please contact ithacaTheEnby if this issue persists.]])
        end
    end)
    :catch(function(err)
        self.player:Kick([[Unable to get menu. 
        Either the game is broken, or your internet connection is poor.
        Please contact ithacaTheEnby if this issue persists.]])
        error(err)
    end)
end

function controller:close(name: string)
    local menu = self.player.PlayerGui:FindFirstChild(name)
    if menu then
        menu:Destroy()
    end
end

return controller