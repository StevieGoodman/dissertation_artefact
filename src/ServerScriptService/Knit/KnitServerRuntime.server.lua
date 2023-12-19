local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServices(script.Parent.Services)
Knit.Start()
:andThenCall(print, "Knit has successfully started on the server!")
:catch(error)