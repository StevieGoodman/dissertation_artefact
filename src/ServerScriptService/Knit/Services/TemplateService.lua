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
    -- TODO: Initialise service.
end

function KnitStart(self)
    -- TODO: Start service.
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
local service = KNIT.CreateService {
    Name      = "Template",
    KnitInit  = KnitInit,
    KnitStart = KnitStart,
}

return service