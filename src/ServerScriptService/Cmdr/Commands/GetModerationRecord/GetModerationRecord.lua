return {
    Name = "GetModerationRecord",
    Description = "Shows the moderation record of a player",
    Group = "moderation",
    Aliases = {
        "moderationrecord","modrecord", "record", "modrec", "modhistory",
        "history", "moderationhistory", "modhist", "getmodhistory", "getmodhist",
        "getmodrecord", "getmodrec", "getrecord", "hist", "viewmodhistory",
        "viewmodhist", "viewmodrecord", "viewmodrec", "viewrecord",
    },
    Args = {
        {
            Type = "player @ playerId # number",
            Name = "target",
            Description = "Whose moderation record to show",
        },
    },
}