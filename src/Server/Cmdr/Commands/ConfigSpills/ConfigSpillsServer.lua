local ServerScriptService = game:GetService("ServerScriptService")

local SpillComponent = require(ServerScriptService.Component.Labour.Spill)

return function(_, minRespawnTime: number?, meanTimeBetween: number?, maxSpills: number?)
    if minRespawnTime then
        SpillComponent.minRespawnTime = minRespawnTime
    end
    if meanTimeBetween then
        SpillComponent.spillMtb = meanTimeBetween
    end
    if maxSpills then
        SpillComponent.setMaxSpills(maxSpills)
    end
    return "Spill respawn time set to " .. minRespawnTime .. " seconds minimum and " .. meanTimeBetween .. " seconds mean time between"
end