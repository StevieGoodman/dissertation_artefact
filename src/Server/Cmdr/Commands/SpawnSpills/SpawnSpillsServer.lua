local ServerScriptService = game:GetService("ServerScriptService")

local SpillComponent = require(ServerScriptService.Component.Labour.Spill)

return function(_, amount: number)
    local spawnedSpills = SpillComponent.spawn(amount)
    return `Spawned {spawnedSpills} spills!`
end