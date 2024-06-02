local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "SCP008Container",
    Ancestors = { workspace }
}

function component:Construct()
    self.particleEffects = Waiter.get.descendants(self.Instance, "ParticleFX")
    self.open = false
end

function component:Start()
    Component.InteractableObject:WaitForInstance(self.Instance, 5)
    :andThen(function(interactableObject)
        interactableObject.interacted:Connect(function()
            self:toggle()
        end)
    end)
    :catch(error)
    :await()
end

--[=[
    Toggles the SCP-008 container, opening it if it is closed and closing it if it is open.
]=]
function component:toggle()
    if self.open then
        self:setOpen(false)
    else
        self:setOpen(true)
    end
end

--[=[
    Sets the open state of the SCP-008 container.
    @param open boolean -- Whether the container should be open.
]=]
function component:setOpen(open: boolean)
    self.open = open
    if open then
        self.Instance:AddTag("SCP008Source")
    else
        self.Instance:RemoveTag("SCP008Source")
    end
    for _, particleEffect in self.particleEffects do
        particleEffect.Enabled = open
    end
end

return component