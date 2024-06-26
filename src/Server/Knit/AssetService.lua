local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

local ASSETS_FOLDER = ReplicatedStorage.Assets
local WAIT_PERIOD = script:GetAttribute("WaitPeriod")

local service = Knit.CreateService {
    Name = "Asset",
}

function service:getAsset(name: string, className: string?): Instance
    local result = nil
    local info = if className then {name = name, className = className} else {name = name}
    local asset = Waiter.waitFor.descendant(ASSETS_FOLDER, info, WAIT_PERIOD)
    if asset then
        result = asset:Clone()
        result.Parent = asset.Parent
        return result
    else
        error(`Unable to find asset with name "{name}"`)
    end
end

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

function service:getAssetsInFolder(tag: Instance)
    local folder = Waiter.get.descendant(ASSETS_FOLDER, {tag = tag, className = "Folder"}, WAIT_PERIOD)
    local assets = Waiter.get.children(folder)
    for _, asset in assets do
        asset = asset:Clone()
        asset.Parent = folder
    end
    return assets
end

return service