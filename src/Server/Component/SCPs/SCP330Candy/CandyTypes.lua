local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
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
        EffectDuration = 34,
        EffectEndFn = function(_, character, transparencyCache: {BasePart: number})
            local bodyParts = Waiter.getDescendants(character, "BasePart", "ClassName") :: {BasePart}
            for _, part in bodyParts do
                if transparencyCache[part] == nil then continue end
                part.Transparency = transparencyCache[part]
            end
            local face = Waiter.getDescendant(character, "Decal", "ClassName") :: Decal
            face.Transparency = 0
        end,
    },
    {
        Colour = BrickColor.new("Deep blue"),
        Name = "Blue",
        EffectStartFn = function(_, character, _)
            local humanoid = Waiter.getDescendant(character, "Humanoid", "ClassName") :: Humanoid
            humanoid.WalkSpeed *= 2
        end,
        EffectDuration = 67,
        EffectEndFn = function(_, character, _)
            local humanoid = Waiter.getDescendant(character, "Humanoid", "ClassName") :: Humanoid
            humanoid.WalkSpeed /= 2
        end,
    },
    {
        Colour = BrickColor.new("Bright red"),
        Name = "Red",
        EffectStartFn = function(_, character, _)
            local humanoid = Waiter.getDescendant(character, "Humanoid", "ClassName") :: Humanoid
            humanoid.MaxHealth *= 2
            humanoid.Health *= 2
        end,
    },
    {
        Colour = BrickColor.new("Bright green"),
        Name = "Green",
        EffectStartFn = function(_, character, _)
            local humanoid = Waiter.getDescendant(character, "Humanoid", "ClassName") :: Humanoid
            humanoid:AddTag("IntervalledDamage")
            Component.IntervalledDamage:WaitForInstance(humanoid)
            :andThen(function(intervalledDamage)
                intervalledDamage:SetDamageAmount(0.025)
                intervalledDamage:SetDamageInterval(0.01)
            end)
        end,
        EffectDuration = 17,
        EffectEndFn = function(_, character, _)
            local humanoid = Waiter.getDescendant(character, "Humanoid", "ClassName") :: Humanoid
            humanoid:RemoveTag("IntervalledDamage")
        end,
    },
    {
        Colour = BrickColor.new("Bright green"),
        Name = "Green",
        EffectStartFn = function(_, character, _)
            local humanoid = Waiter.getDescendant(character, "Humanoid", "ClassName") :: Humanoid
            humanoid:AddTag("IntervalledDamage")
            Component.IntervalledDamage:WaitForInstance(humanoid)
            :andThen(function(intervalledDamage)
                intervalledDamage:SetDamageAmount(-0.025)
                intervalledDamage:SetDamageInterval(0.01)
            end)
        end,
        EffectDuration = 17,
        EffectEndFn = function(_, character, _)
            local humanoid = Waiter.getDescendant(character, "Humanoid", "ClassName") :: Humanoid
            humanoid:RemoveTag("IntervalledDamage")
        end,
    },
} :: {CandyConfig}