return function(_, players: {Player})
    local resultString = ""
    for _, player in players do
        local newValue = not player:GetAttribute("InteractionPermissionsOverride")
        player:SetAttribute("InteractionPermissionsOverride", newValue)
        resultString ..= `Set interaction permissions override for {player} to {newValue}!\n`
    end
    return string.sub(resultString, 1, -2)
end