return function(registry)
	registry:RegisterType(
        "teleportLocation",
        registry.Cmdr.Util.MakeEnumType(
            "TeleportLocation",
            {
                "CDCU Cafeteria",
                "CDCU Viewing Area",
                "DFU Cafeteria",
                "Medical Department",
                "SCP-005",
                "SCP-008",
                "SCP-173",
            }
        )
    )
end