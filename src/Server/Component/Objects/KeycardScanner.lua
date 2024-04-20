local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)
local WaiterV5 = require(ReplicatedStorage.Packages.WaiterV5)

local InteractionObjectComponent = require(script.Parent.InteractionObject)

local READY_COLOR = BrickColor.new("Medium stone grey")
local ACCEPTED_COLOR = BrickColor.new("Bright green")
local DENIED_COLOR = BrickColor.new("Bright red")
local COLOR_DURATION = 0.5

local component = Component.new {
    Tag = "KeycardScanner",
    Ancestors = { workspace }
}

function component:Construct()
    self.interactionObjectComponent = InteractionObjectComponent:FromInstance(self.Instance)
    self.light = WaiterV5.get.descendant(
        self.Instance:FindFirstAncestorWhichIsA("Model"),
        "KeycardScannerLight"
    )
end

function hook(player, keycardScanner)
    local hasPerms = Knit.GetService("InteractionPermissions"):checkPermissions(player, keycardScanner.Instance)
    if hasPerms then
        keycardScanner.light.BrickColor = ACCEPTED_COLOR
    else
        keycardScanner.light.BrickColor = DENIED_COLOR
    end
    Promise.delay(COLOR_DURATION)
    :andThen(function()
        keycardScanner.light.BrickColor = READY_COLOR
    end)
    return hasPerms
end

function component:Start()
    self.interactionObjectComponent.hook = hook
    self.interactionObjectComponent.hookInstance = self
end

return component