--------------- ╭──────────╮ ---------------
--------------- │ SERVICES │ ---------------
--------------- ╰──────────╯ ---------------
local REPL_STORE = game:GetService("ReplicatedStorage")

--------------- ╭──────────╮ ---------------
--------------- │ PACKAGES │ ---------------
--------------- ╰──────────╯ ---------------
local CMDR = require(REPL_STORE:WaitForChild("CmdrClient", 60))

-------------- ╭───────────╮ ---------------
-------------- │ FUNCTIONS │ ---------------
-------------- ╰───────────╯ ---------------
function ConfigureCmdr()
    CMDR:SetActivationKeys {
        Enum.KeyCode.Period
    }
    print("Cmdr has successfully started on the client!")
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
ConfigureCmdr()