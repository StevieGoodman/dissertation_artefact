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
        self:sendNotification("RE-ENTER MAIN MENU", `Hold "M" to re-enter the main menu.`)
    end)
end

function controller:setUpTestQueueNotifications()
    self.testQueueService = Knit.GetService("TestQueue")
    self.testQueueService.newTest:Connect(function(requester: Player, location: string, players: {Players})
        if requester == self.player then
            self:sendNotification("NEW TEST", `You have successfully scheduled a new test in {location} with {#players} players!`)
        elseif table.find(players, self.player) then
            self:sendNotification("NEW TEST", `You have been selected for a test.\nReport to {location} immediately.`)
            self:sendNotification("REJOIN QUEUE", `To rejoin the test queue after the test, respawn as Class-D Personnel.`)
        elseif self.player.Team.Name == "Security Department" then
            self:sendNotification("NEW TEST", `A new test has been scheduled in {location}.`)
        end
    end)
end

function controller:sendNotification(title: string, content: string)
    for _, frame in NotificationFrameComponent:GetAll() do
        frame:queue({
            title = title,
            content = content,
        })
    end
end

return controller