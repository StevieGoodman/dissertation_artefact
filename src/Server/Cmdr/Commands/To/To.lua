return {
    Name        = "To",
    Group       = "moderation",
    Aliases     = {},
    Description = "Teleports the player to a location or another player",
    Args        = {
        {
            Type = "teleportLocation @ player",
            Name = "Destination",
            Description = "The location or player (@username) to teleport to",
        },
    },
}