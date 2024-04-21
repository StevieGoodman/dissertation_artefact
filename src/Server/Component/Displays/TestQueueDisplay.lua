local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "TestQueueDisplay",
    Ancestors = { workspace }
}

function component:Construct()
    self.testQueueService = Knit.GetService("TestQueue")
    self.identityService = Knit.GetService("Identity")
    self.template = Waiter.get.child(self.Instance, "Template")
    self._labels = {}
end

function component:Start()
    Knit.OnStart():await()
    self.testQueueService.playerAdded:Connect(function(player)
        self:onPlayerAdded(player)
    end)
    self.testQueueService.playerRemoved:Connect(function(player)
        self:onPlayerRemoved(player)
    end)
end

function component:onPlayerAdded(player: Player)
    task.wait() -- Identity race condition lies here, must wait for identity to be assigned
    local identity = self.identityService:getPlayerIdentity(player)
    if not identity then return end
    local label = self.template:Clone()
    label.Parent = self.Instance
    self._labels[player] = label
    label.Text = identity
    label.Visible = true
end

function component:onPlayerRemoved(player: Player)
    if not self._labels[player] then return end
    self._labels[player]:Destroy()
    self._labels[player] = nil
end

return component