local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

export type PuddleType = {
    colour: BrickColor, -- The colour of the puddle.
    transparency: number, -- The transparency of the puddle.
    moneyReward: number, -- The money reward for cleaning up the puddle.
}

local component = Component.new {
    Tag = "PuddleSource",
    Ancestors = { workspace }
}

function component:Construct()
    -- Constants
    self.group = self.Instance:GetAttribute("PuddleGroup") or nil
    self.maxPuddles = self.Instance:GetAttribute("MaxPuddles") or 1
    -- Variables
    self.puddles = {}
    self.lastCleanTime = 0
end

function component:Start()
    self.Instance.Transparency = 1
end

--[=[
    Returns whether a puddle can be spawned.
    @return boolean -- Whether a puddle can be spawned.
]=]
function component:canSpawn()
    return #self.puddles < self.maxPuddles
end

--[=[
    Spawns a puddle at the source.
]=]
function component:spawn(type: PuddleType)
    if not self:canSpawn() then
        error("Cannot spawn new puddle")
    else
        local puddle = Component.Puddle.new(
            self:getPosition(),
            type.colour,
            type.transparency,
            type.moneyReward
        )
        
        table.insert(self.puddles, puddle)
        puddle.Stopped:Connect(function(otherPuddle)
            if not self then return end
            local index = table.find(self.puddles, otherPuddle)
            if index == nil then return end
            table.remove(self.puddles, index)
            self.lastCleanTime = os.clock()
        end)
    end
end

--[=[
    Returns the position to spawn puddles at.
    @return Vector3 -- The position to spawn puddles at.
]=]
function component:getPosition()
    return self.Instance:GetPivot().Position
end

return component