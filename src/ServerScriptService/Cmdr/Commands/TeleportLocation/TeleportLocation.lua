return {
    Name        = "TeleportLocation",
    -- Group       = "development",
    Aliases     = { "tploc", "loctp" },
    Description = "Teleports players to a location",
    Args        = {
        {
            Type = "players",
            Name = "Players",
            Description = "The players to teleport",
        },
        {
            Type = "teleportLocation",
            Name = "Location",
            Description = "The location to teleport to",
        },
    },
}