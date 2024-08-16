local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Waiter = require(ReplicatedStorage.Packages.WaiterV6)

export type CandyConfig = {
    Color: BrickColor,
    Name: string,
    EffectStartFn: (player: Player, character: Model, candy: Tool) -> nil,
    EffectDuration: boolean?,
    EffectEndFn: (player: Player, character: Model) -> nil,
}

return {
    {
        Colour = BrickColor.new("Hot pink"),
        Name = "Pink",
        EffectStartFn = function(_, character, tool)
            local explosion = Instance.new("Explosion")
            explosion.ExplosionType = Enum.ExplosionType.NoCraters
            explosion.BlastPressure = 5_000
            explosion.BlastRadius = 8
            explosion.Parent = character
            explosion.Position = tool.Handle.Position
            local bodyParts = Waiter.getChildren(character, "BasePart", "ClassName")
            for _, part in bodyParts do
                part.CanCollide = true
            end
        end,
    }
} :: {CandyConfig}