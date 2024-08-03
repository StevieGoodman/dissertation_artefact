local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = require(ReplicatedStorage.Packages.Cmdr)
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.OnStart():await()

Cmdr:RegisterCommandsIn(script.Commands)
Cmdr:RegisterHooksIn(script.Hooks)
Cmdr:RegisterTypesIn(script.Types)

print("Cmdr has successfully started on the server!")