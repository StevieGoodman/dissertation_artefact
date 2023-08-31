--------------- ╭──────────╮ ---------------
--------------- │ SERVICES │ ---------------
--------------- ╰──────────╯ ---------------
local REPL_STORE = game:GetService("ReplicatedStorage")

--------------- ╭──────────╮ ---------------
--------------- │ PACKAGES │ ---------------
--------------- ╰──────────╯ ---------------
local KNIT = require(REPL_STORE.Packages.Knit)

-------------- ╭───────────╮ ---------------
-------------- │ FUNCTIONS │ ---------------
-------------- ╰───────────╯ ---------------
function SetUpKnit()
    KNIT.AddControllers(script.Parent.Controllers)
    KNIT.Start()
    :andThenCall(print, "Knit has successfully started on the client!")
    :catch(function() error("Unable to start Knit on the client!") end)
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
SetUpKnit()