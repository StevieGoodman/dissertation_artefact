local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

local KEYBIND_KEY           = Enum.KeyCode.M
local KEYBIND_HOLD_DURATION = 1

local controller = Knit.CreateController {
    Name = "MainMenu"
}

function controller:spawnPlayer(team: Team)
    self.respawnService:respawn(team)
    :andThen(print)
    :andThen(function()
        self.player.PlayerGui.MainMenu:Destroy()
    end)
    :catch(warn)
end

function controller:showMainMenu(menu)
    menu.Parent = self.player.PlayerGui
    local buttons = Waiter.waitCollect.descendants(
        menu,
        {
            ClassDPersonnel = { name = "ClassDPersonnel", className = "TextButton" },
            ResearchDepartment = { name = "ResearchDepartment", className = "TextButton" },
            SecurityDepartment = { name = "SecurityDepartment", className = "TextButton" },
            MedicalDepartment = { name = "MedicalDepartment", className = "TextButton" },
        },
        1
    )
    if buttons then
        for _, button in buttons do
            local team = button.ButtonPlayTeam.Value :: Team
            button.MouseButton1Down:Connect(function()
                self:spawnPlayer(team)
            end)
        end
    else
        error("Unable to find main menu buttons")
    end
end

function controller:getMainMenu()
    self.assetService:getAsset("MainMenu")
    :andThen(function(mainMenu)
        if mainMenu then
            self:showMainMenu(mainMenu)
        else
            self.player:Kick([[Unable to get main menu. 
                Either the game is broken, or your internet connection is poor.
                Please contact ithacaTheEnby if this issue persists.]])
        end
    end)
    :catch(function(err)
        self.player:Kick([[Unable to get main menu. 
        Either the game is broken, or your internet connection is poor.
        Please contact ithacaTheEnby if this issue persists.]])
        error(err)
    end)
end

function controller:onMainMenuKeybind(inputObject: InputObject)
    if inputObject.UserInputState ~= Enum.UserInputState.Begin then
        return
    end
    task.wait(KEYBIND_HOLD_DURATION)
    if inputObject.UserInputState ~= Enum.UserInputState.Begin then
        return
    end
    self:getMainMenu()
end

function controller:waitForMainMenuKeybind(player: Players)
    if player ~= self.Plr then
        return
    end
    ContextActionService:BindAction(
        "EnterMainMenu",
        function(_, _, inputObject: InputObject)
            self:onMainMenuKeybind(inputObject)
        end,
        false,
        KEYBIND_KEY
    )
    return function()
        ContextActionService:UnbindAction("EnterMainMenu")
    end
end

function controller:KnitInit()
    self.assetService = Knit.GetService("Asset")
    self.respawnService = Knit.GetService("Respawn")
    self.player = Players.LocalPlayer
end

function controller:KnitStart()
    self:getMainMenu()
    Observers.observeCharacter(function(player: Player)
        self:waitForMainMenuKeybind(player)
    end)
end

return controller