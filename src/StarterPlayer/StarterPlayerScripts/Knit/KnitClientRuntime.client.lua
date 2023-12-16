local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

function setUpKnit()
    Knit.AddControllers(script.Parent.Controllers)
    Knit.Start()
    :andThenCall(print, "Knit has successfully started on the client!")
    :catch(function()
        error("Unable to start Knit on the client!")
    end)
end

setUpKnit()