return {
    Name = "Infect008",
    Description = "Infects a player(s) with SCP-008",
    Group = "development",
    Aliases = { "008", "infectscp008", "scp008", "infect" },
    Args = {
        {
            Type = "players",
            Name = "target",
            Description = "The players to infect",
        },
    },
}