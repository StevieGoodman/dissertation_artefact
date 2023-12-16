local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

local ASSETS_FOLDER = ReplicatedStorage.Assets
local WAIT_PERIOD = script:GetAttribute("WaitPeriod")

local service = Knit.CreateService {
    Name = "Asset",
}

function service.Client:getAsset(_, name: string)
    local result = nil
    local asset = Waiter.waitFor.descendant(ASSETS_FOLDER, {name = name}, WAIT_PERIOD)
    if asset then
        result = asset:Clone()
        result.Parent = asset.Parent
        return result
    else
        error(`Unable to find asset with name "{name}"`)
    end
end

return service