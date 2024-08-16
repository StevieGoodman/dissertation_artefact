local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)
local TopbarPlus = require(ReplicatedStorage.Packages.TopbarPlus)

local PLAYER = Players.LocalPlayer
local KEYBIND_KEY = Enum.KeyCode.M


local controller = Knit.CreateController {
    Name = "MainMenu"
}

function controller:KnitInit()
    self.assetService = Knit.GetService("Asset")
    self.respawnService = Knit.GetService("Respawn")
    self.cursorController = Knit.GetController("Cursor")
end

function controller:KnitStart()
    self:showMainMenu()
    Observers.observeCharacter(function(player: Player, character: Model)
        self:registerKeybind(player)
        character.Humanoid.Died:Connect(function()
            self:deregisterKeybind(player)
        end)
        return function()
            self:deregisterKeybind(player)
        end
    end)
end

function controller:showMainMenu()
    self.assetService:getAsset("MainMenu")
    :andThen(function(mainMenu)
        if mainMenu then
            mainMenu.Parent = PLAYER.PlayerGui
            Knit.GetService("Respawn"):removeCharacter()
            self.cursorController:setCursorIcon(self.cursorController.CursorIcon.Default)
        else
            PLAYER:Kick([[Unable to get main menu.
                Either the game is broken, or your internet connection is poor.
                Please contact ithacaTheEnby if this issue persists.1]])
        end
    end)
    :catch(function(err)
        PLAYER:Kick([[Unable to get main menu.
        Either the game is broken, or your internet connection is poor.
        Please contact ithacaTheEnby if this issue persists.]])
        error(err)
    end)
end

function controller:registerKeybind(player: Player)
    if player ~= PLAYER then
        return
    end
    self.icon = TopbarPlus.new()
    self.icon
        :setLabel("Press M for main menu")
        :oneClick(true)
        :bindEvent("selected", function()
            self:showMainMenu()
        end)
        :bindToggleKey(KEYBIND_KEY)
end

function controller:deregisterKeybind(player: Player)
    if player ~= PLAYER then
        return
    end
    if self.icon then
        self.icon:destroy()
    end
end

return controller