return {
    Name = "showModerationRecord",
    Description = "Shows the moderation record of a player",
    Group = "moderation",
    Args = {
        {
            Type = "player",
            Name = "target",
            Description = "Whose moderation record to show",
        },
    },
}