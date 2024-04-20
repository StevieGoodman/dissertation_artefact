local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local service = Knit.CreateService {
    Name = "InteractionPermissions",
}

function service:getKeycardType(player: Player)
    local keycard = Waiter.get.child(player.Backpack, "Keycard")
    or Waiter.get.child(player.Character, "Keycard")
    return if keycard then keycard:GetAttribute("KeycardType") else nil
end

function service:checkPermissions(player: Player, instance: Instance)
    if player:GetAttribute("InteractionPermissionsOverride") then
        return true
    else
        return instance:GetAttribute(`{self:getKeycardType(player)}Authorised`)
    end
end

function service.Client:checkPermissions(player: Player)
    return self.Server:checkPermissions(player)
end

return service