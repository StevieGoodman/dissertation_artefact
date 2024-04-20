return {
    Name = "JoinTestQueue",
    Description = "Places players in the test queue",
    Group = "development",
    Aliases = {
        "JoinQueue"
    },
    Args = {
        {
            Type = "players",
            Name = "target",
            Description = "Whom to place in the queue",
        },
        {
            Type = "boolean",
            Name = "reassign team",
            Optional = true,
            Description = "If targets players should be assigned to the Class-D Personnel team",
        },
    },
}