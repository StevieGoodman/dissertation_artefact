local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local component = Component.new {
    Tag = "DisableInventory",
    Ancestors = { Players }
}

function component:Construct()
    if not self.Instance:IsA("Player") then
        self.Instance:RemoveTag(self.Tag)
        error(`DisableInventory component can only be attached to Player instances! Instance: {self.Instance}`)
    end
    self.Instance = self.Instance :: Player
end

function component:Start()
    -- Disable current tools
    self.tools = self.Instance.Backpack:GetChildren() :: {Tool}
    if self.Instance.Character then
        table.insert(self.tools, self.Instance.Character:FindFirstChildOfClass("Tool"))
    end
    for _, tool in self.tools do
        tool.Parent = script
    end
    -- Disable any new tools
    self.backpackConnection = self.Instance.Backpack.ChildAdded:Connect(function(tool)
        if not tool:IsA("Tool") then
            return
        end
        tool.Parent = script
        table.insert(self.tools, tool)
    end)
    if self.Instance.Character then
        self.characterConnection = self.Instance.Character.ChildAdded:Connect(function(tool)
            if not tool:IsA("Tool") then
                return
            end
            tool.Parent = script
            table.insert(self.tools, tool)
        end)
    end
end

function component:Stop()
    self.backpackConnection:Disconnect()
    if self.characterConnection then
        self.characterConnection:Disconnect()
    end
    for _, tool in self.tools do
        if self.Instance then
            tool.Parent = self.Instance.Backpack
        else
            tool:Destroy()
        end
    end
end

return component