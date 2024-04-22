local ServerScriptService = game:GetService("ServerScriptService")

local SpillComponent = require(ServerScriptService.Component.Labour.Spill)

return function(_, amount: number)
    local spillsCleaned = SpillComponent.clean(amount)
    return `Cleaned {spillsCleaned} spills!`
end