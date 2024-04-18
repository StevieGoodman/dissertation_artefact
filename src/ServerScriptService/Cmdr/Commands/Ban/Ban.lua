return {
    Name = "TempBan",
    Description = "Bans a set of players from the game for a set period of time",
    Group = "moderation",
    Aliases = { "tban", "temporaryban", "bantemp", "bant", "bantemporary" },
    Args = {
        {
            Type = "players # playerIds",
            Name = "targets",
            Description = "The players to ban",
        },
        {
            Type = "duration",
            Name = "duration",
            Description = "The amount of time to ban the players for",
        },
        {
            Type = "string",
            Name = "reason",
            Description = "The reason the players are being kicked from the server",
        },
    },
}