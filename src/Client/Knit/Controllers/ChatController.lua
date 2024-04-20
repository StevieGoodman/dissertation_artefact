local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local Knit = require(ReplicatedStorage.Packages.Knit)

local controller = Knit.CreateController {
    Name = "Chat",
}

function controller:KnitInit()
    self.testQueueService = Knit.GetService("TestQueue")
end

function controller:KnitStart()
    self.testQueueService.newRequest:Connect(onNewRequest)
    TextChatService.OnIncomingMessage = onIncomingMessage
end

function onIncomingMessage(chatMsg: TextChatMessage)
    local properties = Instance.new("TextChatMessageProperties")
    if chatMsg.TextSource then
        local player = Players:GetPlayerByUserId(chatMsg.TextSource.UserId)
        if player then
            Knit.GetService("Identity"):getPlayerIdentity(player):andThen(
                function(identity)
                    if not identity then return end
                    properties.PrefixText = `{identity}:`
                end
            )
            :catch(function() end):await()
        end
    end
    if chatMsg.Metadata == "SystemMessage" then
        properties.Text = `<font color="rgb(13,105,172)"><font weight="heavy">{chatMsg.Text}</font></font>`
    end
    return properties
end

--[[
    Notifies all players that a test has been created.
--]]
function onNewRequest(players: {Player}, location: string)
    local channel = TextChatService.TextChannels.RBXGeneral :: TextChannel
    local msg = `The following Class-D personnel have been selected for a test:`
    for _, player in players do
        Knit.GetService("Identity"):getPlayerIdentity(player):andThen(
            function(identity)
                msg ..= `\n{identity}`
            end
        ):await()
    end
    msg ..= `\nPlease report to {location} immediately.`
    channel:DisplaySystemMessage(msg, "SystemMessage")
end

return controller