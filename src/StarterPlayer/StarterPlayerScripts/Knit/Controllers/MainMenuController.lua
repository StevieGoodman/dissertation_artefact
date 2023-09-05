--------------- ╭──────────╮ ---------------
--------------- │ SERVICES │ ---------------
--------------- ╰──────────╯ ---------------
local CONTEXT_ACTION_SERV = game:GetService("ContextActionService")
local PLAYERS             = game:GetService("Players")
local REPL_STORE          = game:GetService("ReplicatedStorage")

--------------- ╭──────────╮ ---------------
--------------- │ PACKAGES │ ---------------
--------------- ╰──────────╯ ---------------
local KNIT      = require(REPL_STORE.Packages.Knit)
local OBSERVERS = require(REPL_STORE.Packages.Observers)
local WAIT_FOR  = require(REPL_STORE.Packages.WaitFor)

-------------- ╭───────────╮ ---------------
-------------- │ CONSTANTS │ ---------------
-------------- ╰───────────╯ ---------------
local KEYBIND_KEY           = Enum.KeyCode.M
local KEYBIND_HOLD_DURATION = 1

-------------- ╭───────────╮ ---------------
-------------- │ FUNCTIONS │ ---------------
-------------- ╰───────────╯ ---------------
function SpawnPlr(self, team: Team)
    self.RespawnService:Respawn(team)
    :andThen(print)
    :andThen(function()
        self.Plr.PlayerGui.MainMenu:Destroy()
    end)
    :catch(warn)
end

function ShowMainMenu(self, menu)
    WAIT_FOR.Descendants(
        menu,
        { "ClassD", "Security", "Research" },
        1
    )
    :andThen(function(buttons)
        for _, button in buttons do
            local team = button.Team.Value :: Team
            button.MouseButton1Down:Connect(function()
                SpawnPlr(self, team)
            end)
        end
        menu.Parent = self.Plr.PlayerGui
    end)
    :catch(function(err)
        warn(`Unable to find main menu buttons: {err}`)
    end)
end

function GetMainMenu(self)
    self.AssetService:GetAsset("MainMenu")
    :andThen(function(menu)
        ShowMainMenu(self, menu)
    end)
    :catch(function(_)
        self.Plr:Kick(
            [[Unable to display main menu. 
            Either the game is broken, or your internet connection is poor.
            Please contact CyroStorms if this issue persists.]])
    end)
end

function OnMainMenuKeybind(self, inputObject: InputObject)
    if inputObject.UserInputState == Enum.UserInputState.Begin then
        task.wait(KEYBIND_HOLD_DURATION)
        if inputObject.UserInputState == Enum.UserInputState.Begin then
            GetMainMenu(self)
        end
    end
end

function WaitForMainMenuKeybind(self, player: Players)
    if player ~= self.Plr then
        return
    end
    CONTEXT_ACTION_SERV:BindAction(
        "EnterMainMenu",
        function(_, _, inputObject: InputObject)
            OnMainMenuKeybind(self, inputObject)
        end,
        false,
        KEYBIND_KEY
    )
    return function()
        CONTEXT_ACTION_SERV:UnbindAction("EnterMainMenu")
    end
end

function KnitInit(self)
    self.AssetService   = KNIT.GetService("Asset")
    self.RespawnService = KNIT.GetService("Respawn")
    self.Plr            = PLAYERS.LocalPlayer
end

function KnitStart(self)
    GetMainMenu(self)
    OBSERVERS.observeCharacter(function(player: Player)
        WaitForMainMenuKeybind(self, player)
    end)
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
local controller = KNIT.CreateController {
    Name      = "MainMenu",
    KnitInit  = KnitInit,
    KnitStart = KnitStart,
}

return controller