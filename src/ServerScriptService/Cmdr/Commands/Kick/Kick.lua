return {
    Name = "Kick",
    Description = "Kicks a set of players from the server",
    Group = "moderation",
    Aliases = { "boot", "k" },
    Args = {
        {
            Type = "players # playerIds",
            Name = "targets",
            Description = "The players to kick from the server",
        },
        {
            Type = "string",
            Name = "reason",
            Description = "The reason the players are being kicked from the server",}
    },
}