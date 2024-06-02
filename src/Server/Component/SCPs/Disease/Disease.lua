local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Signal = require(ReplicatedStorage.Packages.Signal)

export type DiseaseSymptom = {
    chance: number,
    progressionThreshold: number | NumberRange,
    addCallback: (humanoid: Humanoid) -> nil,
    removeCallback: (humanoid: Humanoid) -> nil,
}

local component = Component.new {
    Tag = "Disease",
    Ancestors = { workspace }
}

function component:Construct()
    if not self.Instance:IsA("Humanoid") then
        self.Instance:RemoveTag(self.Tag)
        error(`Disease component can only be attached to Humanoid instances! Instance: {self.Instance}`)
    end
    self.Instance = self.Instance :: Humanoid
    self.progress = 0
    self.progressionRate = 0
    self.symptomRegistry = {}
    self.progressChanged = Signal.new()
end

function component:SteppedUpdate(deltaTime: number)
    local oldProgress = self.progress
    self.progress += self.progressionRate * deltaTime
    self.progress = math.clamp(self.progress, 0, 100)
    if self.progress ~= oldProgress then
        self.progressChanged:Fire(self.progress)
        self:UpdateSymptoms()
    end
end

function component:Stop()
    self.progress = 0
    self:UpdateSymptoms()
end

--[[
    Creates a new disease component with a specified progression rate.
--]]
function component.new(humanoid: Humanoid, progressionRate: number | NumberRange)
    return Promise.new(function(resolve, reject, cancel)
        humanoid:AddTag(component.Tag)
        local promise = component:WaitForInstance(humanoid)
        :andThen(function(self)
            self:SetProgressionRate(progressionRate)
            resolve(self)
        end)
        :catch(reject)
        cancel(function()
            promise:cancel()
        end)
    end)
end

--[[
    Factory method for setting the progression rate of the disease.
    Because this method returns the component back, it may be chained with other methods.
--]]
function component:SetProgressionRate(range: number | NumberRange)
    self.progressionRate =
        if typeof(range) == "number"
        then range
        else Random.new():NextNumber(range.Min, range.Max) -- typeof(range) == "NumberRange"
    return self
end

--[[
    Factory method for setting the progression of the disease.
    Because this method returns the component back, it may be chained with other methods.
--]]
function component:SetProgress(progress: number)
    progress = math.clamp(progress, 0, 100)
    self.progress = progress
    return self
end

--[[
    Factory method for adding a symptom to the disease.
    Because this method returns the component back, it may be chained with other methods.
--]]
function component:AddSymptom(symptom: DiseaseSymptom)
    -- Calculate symptom progression threshold if it is a range
    if typeof(symptom.progressionThreshold) == "NumberRange" then
        symptom.progressionThreshold = Random.new():NextNumber(symptom.progressionThreshold.Min, symptom.progressionThreshold.Max)
    end
    -- Check if the symptom will be added
    local willGetSymptom = Random.new():NextNumber(0, 1) < symptom.chance
    if not willGetSymptom then
        return self
    end
    -- Add the symptom to the registry if it will be added
    symptom.active = false
    table.insert(self.symptomRegistry, symptom)
    return self
end

--[[
    Internal lifecycle method that updates the symptoms of the disease applied to the humanoid.
    When the progression of the disease reaches the progression threshold of a symptom, the callback to add the symptom is called.
    When the progression of the disease is below the progression threshold of a symptom, the callback to remove the symptom is called.
--]]
function component:UpdateSymptoms()
    for _, symptom in self.symptomRegistry do
        if self.progress >= symptom.progressionThreshold and not symptom.active then
            symptom.active = true
            symptom.addCallback(self.Instance)
        elseif self.progress < symptom.progressionThreshold and symptom.active then
            symptom.active = false
            symptom.removeCallback(self.Instance)
        end
    end
end

return component