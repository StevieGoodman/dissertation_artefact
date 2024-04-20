return {
    Name = "JoinTestQueue",
    Description = "Places you in the test queue",
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