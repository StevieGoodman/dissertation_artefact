return {
    Name = "pardon",
    Description = "Pardons a moderation event in a player's moderation record",
    Group = "moderation",
    Args = {
        {
            Type = "player @ playerId # integer",
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