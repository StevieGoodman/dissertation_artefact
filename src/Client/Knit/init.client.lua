local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddControllers(script)
Knit.Start()
    :andThenCall(print, "Knit has successfully started on the client!")
    :catch(error)