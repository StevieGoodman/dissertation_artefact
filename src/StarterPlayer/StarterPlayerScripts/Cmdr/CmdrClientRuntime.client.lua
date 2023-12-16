local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient", 60))

function configureCmdr()
    Cmdr:SetActivationKeys {
        Enum.KeyCode.Period
    }
    print("Cmdr has successfully started on the client!")
end

configureCmdr()