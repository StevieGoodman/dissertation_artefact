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
    Gets a player's profile data. It does not return the profile object itself, but rather the data stored in the profile.
--]]
function service:getProfileData(player: Player)
    if not self.profiles[player] then
        task.wait(5)
    end
    if not self.profiles[player] then
        error(`Attempted to read profile data for {player.Name}, but it was not loaded!`)
    end
    return self.profiles[player].Data
end

return service