local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)

local PlayerScripts = Players.LocalPlayer.PlayerScripts
local NotificationFrameComponent = require(PlayerScripts:WaitForChild("Component", 2).UI.NotificationFrame)

local controller = Knit.CreateController {
    Name = "Notification",
}

function controller:KnitInit()
    self.player = Players.LocalPlayer
    self:setUpMainMenuNotifications()
    self:setUpTestQueueNotifications()
end

function controller:setUpMainMenuNotifications()
    self.player.CharacterAdded:Connect(function()
        task.wait()
        if self.player.Team.Name == "Research Department" or
        self.player.Team.Name == "Medical Department" then
            self:send("CREATE A NEW TEST EVENT", `Open the F2 command line and use the NewTest command\nSubject to improvement in future updates`)
        end
    end)
end

function controller:setUpTestQueueNotifications()
    self.testQueueService = Knit.GetService("TestQueue")
    self.testQueueService.newTest:Connect(function(requester: Player, location: string, players: {Players})
        if requester == self.player then
            self:send("CREATED TEST EVENT", `You have scheduled a new test in {location} with {#players} players`)
        elseif table.find(players, self.player) then
            self:send("YOU HAVE BEEN SELECTED FOR A TEST", `Report to {location} immediately`)
            self:send("TO REJOIN TEST QUEUE", `Respawn as Class-D Personnel\nOr use the JoinQueue command in the F2 menu`)
        elseif self.player.Team.Name == "Security Department" then
            self:send("NEW TEST EVENT CREATED", `Escort {#players} Class-D Personnel to {location}`)
        end
    end)
end

function controller:send(title: string, content: string)
    for _, frame in NotificationFrameComponent:GetAll() do
        frame:queue({
            title = title,
            content = content,
        })
    end
end

return controller