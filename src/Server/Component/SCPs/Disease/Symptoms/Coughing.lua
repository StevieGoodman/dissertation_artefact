local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)

local COUGHING_SOUNDS = {
    17711323543,
    17711321258,
    17711316108,
    17711318348,
}

local component = Component.new {
    Tag = "Coughing",
    Ancestors = { workspace }
}

function component:Construct()
    if not self.Instance:IsA("Humanoid") then
        self.Instance:RemoveTag(self.Tag)
        error(`Coughing component can only be attached to Humanoid instances! Instance: {self.Instance}`)
    end
    self.head = self.Instance.Parent.Head
    assert(self.head, "Coughing component requires a head to attach to!")
    self.sound = Instance.new("Sound")
    self.sound.Parent = self.head
    self.sound.RollOffMaxDistance = 50
    self.sound.RollOffMinDistance = 10
    self.intervalRange = nil
    self.lastCough = 0
    self.coughInterval = 0
end

function component:SteppedUpdate(_)
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
        local randomIndex = Random.new():NextInteger(1, #COUGHING_SOUNDS)
        self.sound.SoundId = `rbxassetid://{COUGHING_SOUNDS[randomIndex]}`
        self.sound:Play()
        cancel(function()
            self.sound:Stop()
        end)
        self.sound.Ended:Wait()
        resolve()
    end)
    
end

return component