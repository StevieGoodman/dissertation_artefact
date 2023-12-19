return {
    Name = "releaseName",
    Aliases = { "nameRelease" },
    Description = "Releases a player's name",
    Group = "development",
    Args = {
        {
            Type = "player",
            Name = "for",
            Description = "The player to release the name for",
        },
    },
}