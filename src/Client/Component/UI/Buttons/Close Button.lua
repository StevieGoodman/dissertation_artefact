local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local PLAYER = Players.LocalPlayer

local component = Component.new {
    Tag = "Close Button",
    Ancestors = { PLAYER.PlayerGui }
}

function component:Construct()
    self.Instance = self.Instance :: GuiButton
    self.target = Waiter.get.ancestor(self.Instance, "Close Button Target") or self.Instance:FindFirstAncestorOfClass("ScreenGui") :: Instance
    assert(self.target, "Close Button must have a Close Button Target or a ScreenGui ancestor!")
end

function component:Start()
    self.Instance.MouseButton1Click:Connect(function()
        self.target:Destroy()
    end)
end

return component