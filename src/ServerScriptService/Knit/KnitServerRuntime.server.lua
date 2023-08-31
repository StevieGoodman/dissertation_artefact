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
    KNIT.AddServices(script.Parent.Services)
    KNIT.Start()
    :andThenCall(print, "Knit has successfully started on the server!")
    :catch(function() error("Unable to start Knit on the server!") end)
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
SetUpKnit()