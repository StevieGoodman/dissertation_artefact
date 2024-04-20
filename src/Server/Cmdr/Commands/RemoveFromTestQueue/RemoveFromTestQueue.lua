return {
    Name = "RemoveFromTestQueue",
    Description = "Removes players from the test queue",
    Group = "development",
    Aliases = {
        "RemoveQueue", "RemoveFromQueue"
    },
    Args = {
        {
            Type = "players",
            Name = "target",
            Description = "Whom to place in the queue",
        },
    },
}