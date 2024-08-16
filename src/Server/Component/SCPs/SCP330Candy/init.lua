local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local CandyTypes = require(script.CandyTypes)

local SCP330Candy = Component.new {
    Tag = "SCP330Candy",
    Ancestors = { workspace, Players }
}

function SCP330Candy:Construct()
    self.CandyType = TableUtil.Sample(CandyTypes, 1)[1]
    self.Instance = self.Instance :: Tool
    self.Instance.Handle.BrickColor = self.CandyType.Colour
    self.Instance.Name = `{self.CandyType.Name} candy`
end

function SCP330Candy:Start()
    self.Instance.Activated:Connect(function()
        local character = self.Instance.Parent
        local player = Players:GetPlayerFromCharacter(character)
        local parameters = table.pack(self.CandyType.EffectStartFn(player, character, self.Instance))
        self.Instance:Destroy()
        if self.CandyType.EffectDuration == nil or self.CandyType.EffectEndFn == nil then return end
        task.wait(self.CandyType.EffectDuration)
        if player == nil or character == nil then return end
        self.CandyType.EffectEndFn(player, character, table.unpack(parameters))
    end)
end

return SCP330Candy