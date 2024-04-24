return {
    Name = "GetMoney",
    Description = "Shows a player's money",
    Group = "development",
    Aliases = {
        "ShowMoney",
        "Balance"
    },
    Args = {
        {
            Type = "player",
            Name = "target",
            Description = "Whose money to show",
        },
    },
}