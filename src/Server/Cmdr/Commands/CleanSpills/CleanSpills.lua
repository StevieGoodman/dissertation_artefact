return {
    Name        = "CleanSpills",
    Aliases     = { "CleanSpill", "SpillClean", "SpillsClean" },
    Group        = "development",
    Description = "Cleans a specific amount of spills",
    Args        = {
        {
            Type = "number",
            Name = "Amount",
            Optional = true,
            Description = "Amount of spills to spawn",
        },
    },
}