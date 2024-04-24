local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local component = Component.new {
    Tag = "Unlocked Cursor",
    Descendants = {
        Players.LocalPlayer.PlayerGui
    }
}

function component:Construct()
    Knit.OnStart():await()
    self.cursorController = Knit.GetController("Cursor")
end

function component:Start()
    self.previousMouseBehaviour = Knit.GetController("Cursor"):getMouseBehaviour()
    self.previousCursorIcon = Knit.GetController("Cursor"):getCursorIcon()
    self.cursorController:setMouseBehaviour(Enum.MouseBehavior.Default)
    self.cursorController:setCursorIcon(self.cursorController.CursorIcon.Default)
end

function component:Stop()
    self.cursorController:setMouseBehaviour(self.previousMouseBehaviour)
    self.cursorController:setCursorIcon(self.previousCursorIcon)
end

return component