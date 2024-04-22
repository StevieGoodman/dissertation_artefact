return {
    Name        = "CleanSpills",
    Aliases     = { "CleanSpill", "SpillClean", "SpillsClean" },
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