return {
    Name        = "SpawnSpills",
    Aliases     = { "SpawnSpill", "SpillSpawn", "SpillsSpawn" },
    Description = "Spawns a specific amount of spills",
    Args        = {
        {
            Type = "number",
            Name = "Amount",
            Optional = true,
            Description = "Amount of spills to spawn",
        },
    },
}