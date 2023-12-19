return {
    Name = "reserveName",
    Aliases = { "nameReserve" },
    Description = "Reserves a name for a player",
    Group = "development",
    Args = {
        {
            Type = "player",
            Name = "for",
            Description = "The player to reserve the name for",
        },
    },
}