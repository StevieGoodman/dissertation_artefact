local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.OnStart():await()

require(ReplicatedStorage:WaitForChild("CmdrClient", 60))

print("Cmdr has successfully started on the client!")
