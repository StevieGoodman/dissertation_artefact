return {
    Name = "GetPlayerData",
    Description = "Shows a player's loaded data",
    Group = "development",
    Aliases = {
        "getdata", "data", "showdata", "listdata", "viewdata"
    },
    Args = {
        {
            Type = "player @ playerId # integer",
            Name = "target",
            Description = "Whose data to view",
        },
    },
}