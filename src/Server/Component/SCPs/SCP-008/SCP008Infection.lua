local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(ReplicatedStorage.Packages.Promise)

local AssetService

local PROGRESSION_RATE = NumberRange.new(5, 10)
local SYMPTOMS = {
    { -- IntervalledDamage
        chance = 0.95,
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
        chance = 0.8,
        progressionThreshold = NumberRange.new(20, 70),
        addCallback = function(humanoid)
            humanoid:SetAttribute("InfectionMtb", 20)
            humanoid:SetAttribute("InfectionRange", 5)
            humanoid:AddTag("SCP008Source")
        end,
        removeCallback = function(humanoid)
            humanoid:RemoveTag("SCP008Source")
        end
    },
    { -- Appearance change
        chance = 0.9,
        progressionThreshold = NumberRange.new(20, 80),
        addCallback = function(humanoid)
            humanoid:AddTag("Zombify")
        end,
        removeCallback = function(humanoid)
            humanoid:RemoveTag("Zombify")
        end
    }
}

local component = Component.new {
    Tag = "SCP008Infection",
    Ancestors = { workspace }
}

function component:Construct()
    if not self.Instance:IsA("Humanoid") then
        self.Instance:RemoveTag(self.Tag)
        error(`SCP008Infection component can only be attached to Humanoid instances! Instance: {self.Instance}`)
    end
    Knit.OnStart():await()
    AssetService = Knit.GetService("Asset")
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
    for _, symptom in SYMPTOMS do
        self.disease:AddSymptom(symptom)
    end
end

function component:Stop()
    self.Instance:RemoveTag("Disease")
end

return component