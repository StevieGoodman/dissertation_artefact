local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local SightProbe = require(ServerScriptService.Component.Probes.SightProbeServer)

local service = Knit.CreateService {
    Name = "SightProbe",
}

function service.Client:addObserver(observer: Player, probe: Attachment)
    SightProbe:FromInstance(probe):addObserver(observer)
end

function service.Client:removeObserver(observer: Player, probe: Attachment)
    SightProbe:FromInstance(probe):removeObserver(observer)
end

return service