local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "NewTestDisplay",
    Ancestors = { workspace }
}

function component:Construct()
    self.testQueueService = Knit.GetService("TestQueue")
    self.identityService = Knit.GetService("Identity")
    self._newTestFrameTemplate = Waiter.get.child(self.Instance, "NewTestFrameTemplate")
    self._labels = {}
end

function component:Start()
    Knit.OnStart():await()
    self.testQueueService.newTest:Connect(function(...)
        self:onNewTest(...)
    end)
end

function component:onNewTest(_: Player, location: string, players: {Players})
    task.wait() -- Identity race condition lies here, must wait for identity to be assigned
    local newTestFrame = self._newTestFrameTemplate:Clone()
    newTestFrame.Parent = self._newTestFrameTemplate.Parent
    local locationLabel = Waiter.get.child(newTestFrame, "Title")
    locationLabel.Text = location
    locationLabel.Visible = true
    local identityLabelTemplate = Waiter.get.descendant(newTestFrame, "IdentityLabelTemplate")
    for _, player in players do
        local identity = self.identityService:getPlayerIdentity(player)
        if not identity then return end
        local identityLabel = identityLabelTemplate:Clone()
        identityLabel.Parent = identityLabelTemplate.Parent
        identityLabel.Text = identity
        identityLabel.Visible = true
    end
    newTestFrame.Visible = true
    task.wait(20 + #players * 10)
    newTestFrame:Destroy()
end

return component