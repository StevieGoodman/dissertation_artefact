local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Waiter = require(ReplicatedStorage.Packages.WaiterV6)

export type CandyConfig = {
    Color: BrickColor,
    Name: string,
    EffectStartFn: (player: Player, character: Model, candy: Tool) -> any,
    EffectDuration: number?,
    EffectEndFn: (player: Player, character: Model, parameters: any) -> nil,
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
            local bodyParts = Waiter.getChildren(character, "BasePart", "ClassName") :: {BasePart}
            for _, part in bodyParts do
                part.CanCollide = true
            end

        end,
    },
    {
        Colour = BrickColor.new("White"),
        Name = "White",
        EffectStartFn = function(_, character, _)
            local transparencyCache = {}
            local bodyParts = Waiter.getDescendants(character, "BasePart", "ClassName") :: {BasePart}
            for _, part in bodyParts do
                transparencyCache[part] = part.Transparency
                part.Transparency = 1
            end
            local face = Waiter.getDescendant(character, "Decal", "ClassName") :: Decal
            face.Transparency = 1
            return transparencyCache
        end,
        EffectDuration = 53,
        EffectEndFn = function(_, character, transparencyCache: {BasePart: number})
            local bodyParts = Waiter.getDescendants(character, "BasePart", "ClassName") :: {BasePart}
            for _, part in bodyParts do
                if transparencyCache[part] == nil then continue end
                part.Transparency = transparencyCache[part]
            end
            local face = Waiter.getDescendant(character, "Decal", "ClassName") :: Decal
            face.Transparency = 0
        end,
    }
} :: {CandyConfig}