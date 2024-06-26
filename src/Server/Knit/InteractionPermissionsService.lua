local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local service = Knit.CreateService {
    Name = "InteractionPermissions",
}

function service:getKeycardTypes(player: Player)
    local keycards =
    TableUtil.Extend(
        Waiter.get.children(player.Backpack, "Keycard"),
        Waiter.get.children(player.Character, "Keycard")
    )
    local keycardTypes = TableUtil.Map(keycards, function(keycard)
        return keycard:GetAttribute("KeycardType")
    end)
    return keycardTypes
end

function service:checkPermissions(player: Player, instance: Instance)
    if player:GetAttribute("InteractionPermissionsOverride") then
        return true
    else
        local keycardTypes = self:getKeycardTypes(player)
        return TableUtil.Some(keycardTypes, function(keycardType)
            return instance:GetAttribute(keycardType .. "Authorised")
        end)
    end
end

function service.Client:checkPermissions(player: Player)
    return self.Server:checkPermissions(player)
end

return service