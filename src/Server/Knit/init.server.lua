local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServices(script)
Knit.Start()
    :andThenCall(print, "Knit has successfully started on the server!")
    :catch(error)