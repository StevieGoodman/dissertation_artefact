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
                "Briefing Room A",
                "Briefing Room B",
                "Briefing Room C",
                "Containment Hall",
                "SCP-005",
                "SCP-173",
                "SCP-008",
            }
        )
    )
end