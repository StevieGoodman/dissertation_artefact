local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ProfileService = require(ReplicatedStorage.Packages.ProfileService)
local Observers = require(ReplicatedStorage.Packages.Observers)

local PROFILE_TEMPLATE = {
    secondsPlayed = 0,
    moderationRecord = {},
}

local service = Knit.CreateService {
    Name = "PlayerData",
}

function service:KnitInit()
    self.profileStore = ProfileService.GetProfileStore("PlayerData", PROFILE_TEMPLATE)
    self.profiles = {}
end

function service:KnitStart()
    Observers.observePlayer(function(player)
        self:_loadProfile(player)
        return function()
            self:_releaseProfile(player)
        end
    end)
    -- Ensure any players that joined before the service started have their data loaded
    for _, player in Players:GetPlayers() do
        self:_loadProfile(player)
    end
end

--[[
    Responsible for loading a player's profile into the self.profiles table and
    scheduling profile release when the player leaves the game.
--]]
function service:_loadProfile(player: Player)
    local profile = self.profileStore:LoadProfileAsync(`{player.UserId}`)
    if profile then
        profile:AddUserId(player.UserId)
        profile:Reconcile()
        profile:ListenToRelease(function()
            self.profiles[player] = nil
            player:Kick(
                "Your player data has been loaded by another server.\
                If you haven't joined another server, please contact ithacaTheEnby immediately!"
            )
            print(`Successfully released {player.Name}'s profile.`)
        end)
        if not player:IsDescendantOf(Players) then -- Player has left the game before their data was loaded
            self:_releaseProfile(player)
            print(`Successfully loaded {player.Name}'s profile, however they left the game before data was loaded. Profile has been released.`)
        end
        self.profiles[player] = profile
        self:_processActiveUpdates(profile)
        profile.GlobalUpdates:ListenToNewActiveUpdate(function(updateId, updateData)
            self:_processActiveUpdate(profile, updateId, updateData)
        end)
        print(`Successfully loaded {player.Name}'s profile.`)
    else
        player:Kick(
            "Failed to load player data. Please rejoin in a few moments.\
            Should this issue persist, please contact ithacaTheEnby."
        )
        error(`Failed to load {player.Name}'s profile.`)
    end
end

--[[
    Responsible for releasing  player's profile from the self.profiles table.
    Despite the name, the profile is actually removed from self.profiles by a callback in the _loadData method.
--]]
function service:_releaseProfile(player: Player)
    local profile = self.profiles[player]
    if profile then
        profile:Release()
    end
end

--[[
    Processes all active updates for a player's profile.
--]]
function service:_processActiveUpdates(profile: table)
    for _, updateInfo in profile.GlobalUpdates:GetActiveUpdates() do
        self:_processActiveUpdate(profile, updateInfo[1], updateInfo[2])
    end
end

--[[
    Processes a single active update for a player's profile.
--]]
function service:_processActiveUpdate(profile: table, updateId, updateData)
    profile.GlobalUpdates:LockActiveUpdate(updateId)
    Knit:GetService(updateData.service)[updateData.functionName](
        updateData.service,
        profile,
        table.unpack(updateData.args)
    )
    profile.GlobalUpdates:ClearActiveUpdate(updateId)
end

--[[
    Gets a player's profile. This is a read-only operation, and should not be used to update profile data.
--]]
function service:getProfile(userId: number)
    local player = Players:GetPlayerByUserId(userId)
    if player then
        repeat task.wait()
        until self.profiles[player] or not player:IsDescendantOf(Players)
        return table.clone(self.profiles[player])
    else
        return self.profileStore:ViewProfileAsync(`{userId}`)
    end
end

--[[
    Creates a profile profile update with the given updateData.
--]]
function service:createProfileUpdate(userId: number, updateData: table)
    self.profileStore:GlobalUpdateProfileAsync(
        `{userId}`,
        function(globalUpdates)
            globalUpdates:AddActiveUpdate(updateData)
        end
    )
end



return service