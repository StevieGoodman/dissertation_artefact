return function(registry)
	registry:RegisterType(
        "timeunit",
        registry.Cmdr.Util.MakeEnumType(
            "Time Unit",
            {
                "Days",
                "Weeks",
            }
        )
    )
end