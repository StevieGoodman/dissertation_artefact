local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

Knit.OnStart():await()
local AssetService = Knit.GetService("Asset")
local MoneyService = Knit.GetService("Money")

local component = Component.new {
    Tag = "Puddle",
    Ancestors = { workspace }
}

component.keyboardKeyCode = Enum.KeyCode.E -- Key to press to clean up the spill
component.gamepadKeyCode = Enum.KeyCode.ButtonX -- Gamepad button to press to clean up the spill
component.holdTime = 5 -- Time to hold the key to clean up the spill
component.defaultMoneyReward = 0 -- The default money reward for cleaning up the puddle
component.puddleFolder = Waiter.get.descendant(workspace, "PuddleFolder") or workspace

--[=[
    Creates a new puddle at a specified position in the world.
    @param position -- The position of the puddle.
    @param colour -- The colour of the puddle.
    @param transparency -- The transparency of the puddle.
    @param moneyReward -- The amount of money the player will receive for cleaning up the puddle.
]=]
function component.new(position: Vector3, colour: BrickColor, transparency: number, moneyReward: number)
    local self = AssetService:getAsset("Puddle")
    self:SetAttribute("MoneyReward", moneyReward or self.defaultMoneyReward)
    local cframe = CFrame.new(position) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
    self:PivotTo(cframe)
    self.BrickColor = colour or BrickColor.new("Medium blue")
    self.Transparency = transparency or 0.5
    self.Parent = component.puddleFolder
    local puddleComponent
    component:WaitForInstance(self)
    :andThen(function(result)
        puddleComponent = result
    end)
    :catch(error)
    :await()
    return puddleComponent
end

function component:Construct()
    self.moneyReward = self.Instance:GetAttribute("MoneyReward") or self.defaultMoneyReward
end

function component:Start()
    self:createProximityPrompt()
end

function component:createProximityPrompt()
    self.proximityPrompt = Instance.new("ProximityPrompt") :: ProximityPrompt
    self.proximityPrompt.Parent = self.Instance
    self.proximityPrompt.ActionText = "Clean up"
    self.proximityPrompt.ObjectText = "Puddle"
    self.proximityPrompt.KeyboardKeyCode = self.keyboardKeyCode
    self.proximityPrompt.GamepadKeyCode = self.gamepadKeyCode
    self.proximityPrompt.RequiresLineOfSight = false
    self.proximityPrompt.HoldDuration = self.holdTime
    self.proximityPrompt:AddTag("CleanPrompt")
    self.proximityPrompt.Triggered:Connect(function(player: Player)
        self:rewardPlayer(player)
        self.Instance:Destroy()
    end)
end

function component:rewardPlayer(player: Player)
    if self.moneyReward <= 0 then return end
    MoneyService:add(player, self.moneyReward)
end

return component