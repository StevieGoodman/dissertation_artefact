return {
    Name = "kick",
    Description = "Kicks a set of players from the server",
    Group = "moderation",
    Args = {
        {
            Type = "players",
            Name = "targets",
            Description = "The players to kick from the server",
        },
        {
            Type = "string",
            Name = "reason",
            Description = "The reason the players are being kicked from the server",}
    },
}