local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)
local TopBarPlus = require(ReplicatedStorage.Packages.TopBarPlus)

local KEYBIND_KEY = Enum.KeyCode.M

local controller = Knit.CreateController {
    Name = "MainMenu"
}

function controller:KnitInit()
    self.assetService = Knit.GetService("Asset")
    self.respawnService = Knit.GetService("Respawn")
    self.player = Players.LocalPlayer
    self.cursorController = Knit.GetController("Cursor")
end

function controller:KnitStart()
    self:showMainMenu()
    Observers.observeCharacter(function(player: Player)
        self:registerKeybind(player)
    end)
end

function controller:showMainMenu()
    self.assetService:getAsset("MainMenu")
    :andThen(function(mainMenu)
        if self.icon then
            self.icon:destroy()
        end
        if mainMenu then
            mainMenu.Parent = self.player.PlayerGui
            Knit.GetService("Respawn"):removeCharacter()
            self.cursorController:setCursorIcon(self.cursorController.CursorIcon.Default)
        else
            self.player:Kick([[Unable to get main menu. 
                Either the game is broken, or your internet connection is poor.
                Please contact ithacaTheEnby if this issue persists.1]])
        end
    end)
    :catch(function(err)
        self.player:Kick([[Unable to get main menu. 
        Either the game is broken, or your internet connection is poor.
        Please contact ithacaTheEnby if this issue persists.]])
        error(err)
    end)
end

function controller:registerKeybind(player: Players)
    if player ~= self.player then
        return
    end
    self.icon = TopBarPlus.new()
    self.icon
        :setLabel("Main Menu")
        :setImage("rbxassetid://17492921179")
        :oneClick(true)
        :bindEvent("selected", function()
            self:showMainMenu()
        end)
        :bindToggleKey(KEYBIND_KEY)
end

return controller