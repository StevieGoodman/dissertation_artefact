local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = require(ReplicatedStorage.Packages.Cmdr)

return function(_)
    local commands = Cmdr.Registry:GetCommands()
    local response = ""
    for _, info in commands do
        response ..= `[{info.Group or "player"}] {info.Name}: {info.Description}\n`
    end
    return string.sub(response, 1, -2)
end