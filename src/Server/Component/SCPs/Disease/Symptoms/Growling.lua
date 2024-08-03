local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)

local GROWLING_SOUNDS = {
    17711764224,
    17711763922,
    17711763635,
    17711763388,
    17711763161,
}

local component = Component.new {
    Tag = "Growling",
    Ancestors = { workspace }
}

function component:Construct()
    if not self.Instance:IsA("Humanoid") then
        self.Instance:RemoveTag(self.Tag)
        error(`Growling component can only be attached to Humanoid instances! Instance: {self.Instance}`)
    end
    self.head = self.Instance.Parent.Head
    assert(self.head, "Growling component requires a head to attach to!")
    self.sound = Instance.new("Sound")
    self.sound.Parent = self.head
    self.sound.RollOffMaxDistance = 50
    self.sound.RollOffMinDistance = 10
    self.intervalRange = nil
    self.lastCough = 0
    self.coughInterval = 0
    self.Instance.Died:Connect(function()
        self.Instance:RemoveTag(self.Tag)
    end)
end

function component:SteppedUpdate(_)
    self.head:RemoveTag("Coughing")
    if not self.intervalRange then
        return
    end
    local timeSinceLastCough = os.clock() - self.lastCough
    if timeSinceLastCough >= self.coughInterval then
        self.lastCough = os.clock()
        self.coughInterval = Random.new():NextNumber(self.intervalRange.Min, self.intervalRange.Max)
        self:PlaySound()
    end
end

function component:SetIntervalRange(intervalRange: NumberRange)
    self.intervalRange = intervalRange
    return self
end

function component:PlaySound()
    return Promise.new(function(resolve, _, cancel)
        local randomIndex = Random.new():NextInteger(1, #GROWLING_SOUNDS)
        self.sound.SoundId = `rbxassetid://{GROWLING_SOUNDS[randomIndex]}`
        self.sound:Play()
        cancel(function()
            self.sound:Stop()
        end)
        self.sound.Ended:Wait()
        resolve()
    end)
    
end

return component