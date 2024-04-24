return {
    Name = "AddMoney",
    Description = "Gives players money",
    Group = "development",
    Aliases = {
        "GiveMoney"
    },
    Args = {
        {
            Type = "players",
            Name = "targets",
            Description = "Whom to give money to",
        },
        {
            Type = "number",
            Name = "amount",
            Description = "How much money to give the players",
        },
    },
}