return {
    Name = "reassignIdentity",
    Description = "Reassigns a player's identity",
    Group = "development",
    Args = {
        {
            Type = "player",
            Name = "of",
            Description = "The player to reassign the identity of",
        },
        {
            Type = "string",
            Name = "to",
            Description = "The identity to assign to the player",
            Optional = true,
        },
    },
}