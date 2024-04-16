return {
    Name = "pardon",
    Description = "Pardons a moderation event in a player's moderation record",
    Group = "moderator",
    Args = {
        {
            Type = "player",
            Name = "target",
            Description = "Subject of the pardon",
        },
        {
            Type = "number",
            Name = "id",
            Description = "ID of the moderation event to pardon",
        },
        {
            Type = "string",
            Name = "reason",
            Description = "Reason for the pardon",
        },
    },
}