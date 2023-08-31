--------------- ╭──────────╮ ---------------
--------------- │ SERVICES │ ---------------
--------------- ╰──────────╯ ---------------
local REPL_STORE = game:GetService("ReplicatedStorage")

--------------- ╭──────────╮ ---------------
--------------- │ PACKAGES │ ---------------
--------------- ╰──────────╯ ---------------
local CMDR = require(REPL_STORE.Packages.Cmdr)

-------------- ╭───────────╮ ---------------
-------------- │ FUNCTIONS │ ---------------
-------------- ╰───────────╯ ---------------
function SetUpCmdr()
    CMDR:RegisterCommandsIn(script.Parent.Commands)
    CMDR:RegisterHooksIn(script.Parent.Hooks)
    CMDR:RegisterTypesIn(script.Parent.Types)
    print("Cmdr has successfully started on the server!")
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
SetUpCmdr()