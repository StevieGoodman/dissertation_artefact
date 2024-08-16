local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Waiter = require(ReplicatedStorage.Packages.WaiterV6)

local teleportLocations = Waiter.getChild(workspace, "TeleportLocationsFolder"):GetChildren()
local locationNames = TableUtil.Map(teleportLocations, function(location)
    return location.Name
end)
table.sort(locationNames)

return function(registry)
	registry:RegisterType(
        "teleportLocation",
        registry.Cmdr.Util.MakeEnumType(
            "TeleportLocation",
            locationNames
        )
    )
end