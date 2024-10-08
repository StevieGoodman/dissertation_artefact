local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)

local service = Knit.CreateService {
    Name = "ToolDrop",
}

service.maxDropDistance = 3

function service:KnitInit()
    self.assetService = Knit.GetService("Asset")
end

function service:KnitStart()
    Observers.observeCharacter(function(player: Player, character: Model)
        local humanoid = character:WaitForChild("Humanoid", 1)
        humanoid.Died:Connect(function()
            self:dropTools(player, character)
        end)
    end)
end

function service:dropTools(player: Player, character: Model)
    -- Get a list of all the tools the player has
    local tools = player.Backpack:GetChildren()
    local equipped = character:FindFirstChildOfClass("Tool")
    table.insert(tools, equipped)
    -- Attempt to drop each tool
    for _, tool in tools do
        local chanceToDrop = tool:GetAttribute("DropChance") or 0.5
        local dropTool = math.random(1, 100) < chanceToDrop * 100
        if not dropTool then continue end
        tool.Parent = player.Backpack -- Equipped tools cannot be reparented so they despawn with the character
        self:dropTool(character.HumanoidRootPart.Position, tool)
    end
end

function service:dropTool(at: Vector3, tool: Tool)
    local random = Random.new()
    local dropAngle = random:NextNumber(0, math.pi * 2)
    local dropDistance = random:NextNumber(0, self.maxDropDistance)
    local unitVector = Vector3.new(math.cos(dropAngle), 0, math.sin(dropAngle))
    local dropPosition = at + unitVector * dropDistance
    tool = tool:Clone() -- Even when reparented, the original despawns with the character
    tool.Parent = workspace
    tool:MoveTo(dropPosition)
    self:addProximityPrompt(tool)
end

function service:addProximityPrompt(tool: Tool)
    local proximityPrompt = Instance.new("ProximityPrompt")
    proximityPrompt.ActionText = "Pick up"
    proximityPrompt.ObjectText = tool.Name
    proximityPrompt.HoldDuration = 0.5
    proximityPrompt.Parent = tool.PrimaryPart or tool.Handle
    proximityPrompt.Triggered:Once(function(player: Player)
        if not player.Character or player.Character.Humanoid.Health <= 0 then return end
        tool.Parent = player.Backpack
        proximityPrompt:Destroy()
    end)
end

return service