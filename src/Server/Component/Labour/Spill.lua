local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

local component = Component.new {
    Tag = "Spill",
    Ancestors = { workspace }
}

component.spillMtb = 30 -- Mean Time Between spills (in seconds)
component.minRespawnTime = 30 -- Minimum time before the spill can respawn (in seconds)
component.maxSpills = 3 -- Maximum number of spills that can be shown at once

component.keyboardKeyCode = Enum.KeyCode.E -- Key to press to clean up the spill
component.gamepadKeyCode = Enum.KeyCode.ButtonX -- Gamepad button to press to clean up the spill
component.holdTime = 1 -- Time to hold the key to clean up the spill

function component.getSpillCount()
    local spills = component:GetAll()
    local shownSpills = TableUtil.Filter(spills, function(spill)
        return spill.shown
    end)
    return #shownSpills
end

function component.spawn(amount: number?)
    local hiddenSpills = TableUtil.Filter(
        component:GetAll(),
        function(spill)
            return not spill.shown and component.getSpillCount() < component.maxSpills
        end
    )
    local spillsToSpawn = TableUtil.Sample(hiddenSpills, amount or #hiddenSpills)
    for _, spill in spillsToSpawn do
        spill:show()
    end
    return #spillsToSpawn
end

function component.clean(amount: number?)
    local shownSpills = TableUtil.Filter(
        component:GetAll(),
        function(spill)
            return spill.shown
        end
    )
    local spillsToClean = TableUtil.Sample(shownSpills, amount or #shownSpills)
    for _, spill in spillsToClean do
        spill:hide()
    end
    return #spillsToClean
end

function component.setMaxSpills(amount: number)
    component.maxSpills = amount
    local shownSpillsCount = component.getSpillCount()
    if shownSpillsCount > amount then
        component.clean(shownSpillsCount - amount)
    end
end

function component:Construct()
    self.random = Random.new()
    self.proximityPrompt = Instance.new("ProximityPrompt") :: ProximityPrompt
    self.proximityPrompt.Parent = self.Instance
    self.proximityPrompt.ActionText = "Clean up"
    self.proximityPrompt.ObjectText = "Spill"
    self.proximityPrompt.KeyboardKeyCode = self.keyboardKeyCode
    self.proximityPrompt.GamepadKeyCode = self.gamepadKeyCode
    self.proximityPrompt.HoldDuration = self.holdTime
    self.proximityPrompt:AddTag("CleanPrompt")
    self.proximityPrompt.Triggered:Connect(function()
        self:hide()
    end)
end

function component:Start()
    self:hide()
end

function component:SteppedUpdate(deltaTime)
    local minRespawnTimePassed = os.clock() > self.lastCleanUpTime + self.minRespawnTime
    if self.shown or not minRespawnTimePassed then return end
    -- Roll according to the mean time between spills
    if self.random:NextNumber() < deltaTime / self.spillMtb then
        self:show()
    end
end

function component:show()
    if self.getSpillCount() >= self.maxSpills then return end
    self.Instance.Transparency = 0
    self.shown = true
    self.proximityPrompt.Enabled = true
end

function component:hide()
    self.Instance.Transparency = 1
    self.shown = false
    self.proximityPrompt.Enabled = false
    self.lastCleanUpTime = os.clock()
end

return component