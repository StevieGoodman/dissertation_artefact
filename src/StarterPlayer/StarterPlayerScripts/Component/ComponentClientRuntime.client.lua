function setUpComponent()
    for _, object in script.Parent:GetChildren() do
        if not object:IsA("ModuleScript") then
            continue
        end
        require(object)
    end

    print(`Component has successfully started on the client!`)
end

setUpComponent()