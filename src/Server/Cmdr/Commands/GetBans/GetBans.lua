return {
    Name = "GetBans",
    Description = "Shows previous bans applied to a specific player",
    Group = "moderation",
    Aliases = {
        "Bans"
    },
    Args = {
        {
            Type = "player @ playerId # number",
            Name = "target",
            Description = "Whose previous bans to display",
        },
    },
}