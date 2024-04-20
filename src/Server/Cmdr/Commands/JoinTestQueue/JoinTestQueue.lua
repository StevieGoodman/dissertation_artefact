return {
    Name = "JoinTestQueue",
    Description = "Shows the test queue's contents",
    Group = "development",
    Aliases = {
        "JoinQueue"
    },
    Args = {
        {
            Type = "boolean",
            Name = "reassign team",
            Optional = true,
            Description = "If you should be assigned to the Class-D Personnel team",
        },
    },
}