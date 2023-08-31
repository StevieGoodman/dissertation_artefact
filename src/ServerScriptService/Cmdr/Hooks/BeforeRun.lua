-------------- ╭───────────╮ ---------------
-------------- │ FUNCTIONS │ ---------------
-------------- ╰───────────╯ ---------------
function Hook(context)
    -- TODO: Add permissions system.
end

function Register(registry)
    registry:RegisterHook("BeforeRun", Hook)
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
return Register