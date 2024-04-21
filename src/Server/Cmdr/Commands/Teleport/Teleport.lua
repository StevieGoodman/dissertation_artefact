return {
    Name        = "Teleport",
    Group       = "moderation",
    Aliases     = { "TP" },
    Description = "Teleports players to a location or player",
    Args        = {
        {
            Type = "players",
            Name = "Players",
            Description = "The players to teleport",
        },
        {
            Type = "teleportLocation @ player",
            Name = "Destination",
            Description = "The location or player (@username) to teleport to",
        },
    },
}