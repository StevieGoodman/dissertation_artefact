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
function KnitInit(self)
    -- TODO: Initialise controller.
end

function KnitStart(self)
    -- TODO: Start controller.
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
local controller = KNIT.CreateController {
    Name      = "Template",
    KnitInit  = KnitInit,
    KnitStart = KnitStart,
}

return controller