local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)

local PROGRESSION_RATE = NumberRange.new(0.5, 1)

local component = Component.new {
    Tag = "SCP008Infection",
    Ancestors = { workspace }
}

function component:Construct()
    self.symptoms = {
        { -- IntervalledDamage
            chance = 0.8,
            progressionThreshold = 100,
            addCallback = function(humanoid)
                humanoid:AddTag("IntervalledDamage")
                Component.IntervalledDamage:WaitForInstance(humanoid)
                    :andThen(function(intervalledDamage)
                        intervalledDamage
                            :SetDamageInterval(NumberRange.new(0.5, 4))
                            :SetDamageAmount(NumberRange.new(2, 5))
                    end)
            end,
            removeCallback = function(humanoid)
                humanoid:RemoveTag("IntervalledDamage")
            end
        },
        { -- Contagiousness
            chance = 0.6,
            progressionThreshold = Random.new():NextNumber(10, 50),
            addCallback = function(humanoid)
                humanoid:SetAttribute("InfectionMtb", 20)
                humanoid:SetAttribute("InfectionRange", 5)
                humanoid:AddTag("SCP008Source")
                humanoid:AddTag("Coughing")
                Component.Coughing:WaitForInstance(humanoid)
                    :andThen(function(coughing)
                        coughing:SetIntervalRange(NumberRange.new(10, 30))
                    end)
            end,
            removeCallback = function(humanoid)
                humanoid:RemoveTag("SCP008Source")
                humanoid:RemoveTag("Coughing")
            end
        },
        { -- Zombification
            chance = 0.75,
            progressionThreshold = Random.new():NextNumber(30, 80),
            addCallback = function(humanoid)
                humanoid:AddTag("Zombify")
                humanoid:AddTag("Growling")
                Component.Growling:WaitForInstance(humanoid)
                    :andThen(function(growling)
                        growling:SetIntervalRange(NumberRange.new(5, 10))
                    end)
            end,
            
            removeCallback = function(humanoid)
                humanoid:RemoveTag("Zombify")
                humanoid:RemoveTag("Growling")
            end
        },
    }

    if not self.Instance:IsA("Humanoid") then
        self.Instance:RemoveTag(self.Tag)
        error(`SCP008Infection component can only be attached to Humanoid instances! Instance: {self.Instance}`)
    end
    Knit.OnStart():await()
    self:AddDependencies():await()
end

function component:AddDependencies()
    return Promise.new(function(resolve, reject, cancel)
        local promise = Component.Disease.new(self.Instance, PROGRESSION_RATE)
            :andThen(function(disease)
                self.disease = disease
                resolve()
            end)
            :catch(reject)
        cancel(function()
            promise:cancel()
        end)
    end)
end

function component:Start()
    print(`{self.Instance.Parent.Name} has been infected with SCP-008!`)
    for _, symptom in self.symptoms do
        self.disease:AddSymptom(symptom)
    end
end

function component:Stop()
    self.Instance:RemoveTag("Disease")
end

return component