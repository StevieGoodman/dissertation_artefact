return {
    Name = "RemoveMoney",
    Description = "Takes players' money",
    Group = "development",
    Aliases = {
        "TakeMoney"
    },
    Args = {
        {
            Type = "players",
            Name = "targets",
            Description = "Whom to take money from",
        },
        {
            Type = "number",
            Name = "amount",
            Description = "How much money to take away from the players",
        },
    },
}