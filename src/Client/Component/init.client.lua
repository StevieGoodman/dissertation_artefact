local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.OnStart():await()

for _, object in script:GetDescendants() do
    if not object:IsA("ModuleScript") then continue end
    assert(not Component[object.Name], `Conflicting component name: {object.Name}!`)
    Component[object.Name] = require(object)
end

print(`Component has successfully started on the client!`)