local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local KEYBIND_KEY           = Enum.KeyCode.M
local KEYBIND_HOLD_DURATION = 1



local controller = Knit.CreateController {
    Name = "MainMenu"
}

function controller:KnitInit()
    self.assetService = Knit.GetService("Asset")
    self.respawnService = Knit.GetService("Respawn")
    self.player = Players.LocalPlayer
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
        if mainMenu then
            mainMenu.Parent = self.player.PlayerGui
            Knit.GetService("Respawn").removeCharacter()
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
    ContextActionService:BindAction(
        "EnterMainMenu",
        function(_, _, inputObject: InputObject)
            self:onKeybind(inputObject)
        end,
        false,
        KEYBIND_KEY
    )
    return function()
        ContextActionService:UnbindAction("EnterMainMenu")
    end
end

function controller:onKeybind(inputObject: InputObject)
    if inputObject.UserInputState ~= Enum.UserInputState.Begin then
        return
    end
    task.wait(KEYBIND_HOLD_DURATION)
    if inputObject.UserInputState ~= Enum.UserInputState.Begin then
        return
    end
    self:showMainMenu()
end

return controller