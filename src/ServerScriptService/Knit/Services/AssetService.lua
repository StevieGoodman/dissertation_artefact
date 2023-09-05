--------------- ╭──────────╮ ---------------
--------------- │ SERVICES │ ---------------
--------------- ╰──────────╯ ---------------
local REPL_STORE = game:GetService("ReplicatedStorage")

--------------- ╭──────────╮ ---------------
--------------- │ PACKAGES │ ---------------
--------------- ╰──────────╯ ---------------
local KNIT     = require(REPL_STORE.Packages.Knit)
local PROMISE  = require(REPL_STORE.Packages.Promise)
local WAIT_FOR = require(REPL_STORE.Packages.WaitFor)

-------------- ╭───────────╮ ---------------
-------------- │ CONSTANTS │ ---------------
-------------- ╰───────────╯ ---------------
local ASSETS_FOLDER = REPL_STORE.Assets
local WAIT_PERIOD   = 5

-------------- ╭───────────╮ ---------------
-------------- │ FUNCTIONS │ ---------------
-------------- ╰───────────╯ ---------------
function GetAsset(_, _, name: string)
    local result = nil
    WAIT_FOR.Descendant(ASSETS_FOLDER, name, WAIT_PERIOD)
    :andThen(function(asset)
        result = asset:Clone()
        result.Parent = asset.Parent
    end)
    :catch(function(_)
        error(`Unable to find asset with name "{name}"`)
    end)
    return result
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
local service = KNIT.CreateService {
    Name   = "Asset",
    Client = {
        GetAsset = GetAsset
    }
}

return service