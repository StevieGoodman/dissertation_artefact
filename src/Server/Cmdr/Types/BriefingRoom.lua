return function(registry)
	registry:RegisterType(
        "briefingroom",
        registry.Cmdr.Util.MakeEnumType(
            "BriefingRoom",
            {
                "Briefing Room A",
                "Briefing Room B",
                "Briefing Room C",
            }
        )
    )
end