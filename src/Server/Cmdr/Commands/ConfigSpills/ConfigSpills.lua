return {
    Name        = "ConfigSpills",
    Aliases     = { "SpillsConfig" },
    Description = "Configures the spill respawn time",
    Args        = {
        {
            Type = "number",
            Name = "Minimum respawn time",
            Optional = true,
            Description = "The minimum time before spills can respawn (in seconds)",
        },
        {
            Type = "number",
            Name = "Mean time between",
            Optional = true,
            Description = "The mean time between spills respawning (in seconds)",
        },
        {
            Type = "number",
            Name = "Max spills",
            Optional = true,
            Description = "The maximum number of spills that can be shown at once",
        },
    },
}