local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Timer = require(ReplicatedStorage.Packages.Timer)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Waiter = require(ReplicatedStorage.Packages.WaiterV6)

local MUTILATION_THRESHOLD = 2

local SCP330 = Component.new {
    Tag = "SCP330",
    Ancestors = { workspace },
    Extensions = {{
        ShouldConstruct = function(self)
            local prompt =  Waiter.getDescendant(self.Instance, "ProximityPrompt", "ClassName")
            assert(prompt, `SCP-330 is missing a ProximityPrompt. ({self.Instance:GetFullName()})`)
            return true
        end,
    }},
}

function SCP330:Construct()
    self.Trove = Trove.new()
    self.Prompt = Waiter.getDescendant(self.Instance, "ProximityPrompt", "ClassName") :: ProximityPrompt
end

function SCP330:Start()
    local connection = self.Prompt.Triggered:Connect(function(player)
        self:OnInteract(player)
    end)
    self.Trove:Add(connection)
end

function SCP330:Stop()
    self.Trove:Clean()
end

function SCP330:OnInteract(player: Player)
    local candyCount = player.Character:GetAttribute("CandyCount") or 0
    local shouldMutilate = candyCount >= MUTILATION_THRESHOLD
    if shouldMutilate then
        self:Mutilate(player)
    else
        self:GiveCandy(player)
    end
    player.Character:SetAttribute("CandyCount", candyCount + 1)
end

function SCP330:GiveCandy(player: Player)
end

function SCP330:Mutilate(player: Player)
    local characterParts = Waiter.getChildren(player.Character, "BasePart", "ClassName")
    local hands = TableUtil.Filter(characterParts, function(part)
        return string.find(part.Name, "Hand") ~= nil
    end) :: {BasePart}
    for _, hand in hands do
        hand.CanCollide = true
        local motor6d = Waiter.getChild(hand, "Motor6D", "ClassName") :: Motor6D
        motor6d:Destroy()
    end

    local tools = player.Backpack:GetChildren()
    table.insert(tools, Waiter.getChildren(player.Character, "Tool", "ClassName"))
    for _, tool in player.Backpack:GetChildren() do
        tool:Destroy()
    end

    local humanoid = Waiter.getDescendant(player.Character, "Humanoid", "ClassName") :: Humanoid
    humanoid:AddTag("IntervalledDamage")
    Component.IntervalledDamage:WaitForInstance(humanoid)
    :andThen(function(intervalledDamage)
        intervalledDamage:SetDamageAmount(0.025)
        intervalledDamage:SetDamageInterval(0.01)
    end)
end

return SCP330