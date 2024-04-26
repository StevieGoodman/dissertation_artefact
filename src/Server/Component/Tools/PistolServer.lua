local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Waiter = require(ReplicatedStorage.Packages.Waiter)
local WaiterV5 = require(ReplicatedStorage.Packages.WaiterV5)

local component = Component.new {
    Tag = "Pistol",
}

function component:Construct()
    self.bulletOrigin = Waiter.get.descendant(self.Instance, { tag = "BulletOrigin" })
    self.fireSoundTemplate = Waiter.get.descendant(self.Instance, { tag = "FireSoundTemplate" })
    self.reloadSoundTemplate = Waiter.get.descendant(self.Instance, { tag = "ReloadSoundTemplate" })
    self.muzzleFlashEmitter = Waiter.get.descendant(self.Instance, { tag = "MuzzleFlashEmitter" })
    self.muzzleFlashLight = Waiter.get.descendant(self.Instance, { tag = "MuzzleFlashLight" })
    self.aimAnimation = WaiterV5.get.child(self.Instance, "AimAnimation")
    assert(self.aimAnimation, "AimAnimation not found!")
    self.nextShotTime = 0
end

function component:Start()
    self.Instance.Equipped:Connect(function()
        self:setUpAnimations()
    end)
    self.Instance.Activated:Connect(function()
        print("Activated")
    end)
end

function component:fire(at: Vector3, player: Player)
    -- Check the player can fire the weapon
    local bulletOrigin = self:getBulletOrigin()
    if not bulletOrigin then return end
    if self.Instance:GetAttribute("Ammo") <= 0 then return end
    if self.Instance:GetAttribute("Reloading") then return end
    if os.clock() < self.nextShotTime then return end
    self.nextShotTime = os.clock() + 1 / (self.Instance:GetAttribute("RPM") / 60)
    -- Play the fire sound
    local fireSound = self.fireSoundTemplate:Clone()
    fireSound.Parent = self.fireSoundTemplate.Parent
    fireSound.TimePosition = 0.05
    fireSound:Play()
    -- Fire the gun
    local shotResult = self:getShotResult(bulletOrigin, at, player)
    local ammo = self.Instance:GetAttribute("Ammo")
    self.Instance:SetAttribute("Ammo", ammo - 1)
    self:createShotEffect(shotResult)
    local humanoid = self:getHumanoidFromPart(shotResult.Instance)
    if not humanoid then return end
    local range = (bulletOrigin - at).Magnitude
    local damage = self:getDamageFromRange(range)
    humanoid:TakeDamage(damage)
    -- Clean up the fire sound
    fireSound.Ended:Wait()
    fireSound:Destroy()
end

function component:reload()
    if self.Instance:GetAttribute("Reloading") then return end
    local reloadTime = self.Instance:GetAttribute("ReloadTime")
    local ammoCapacity = self.Instance:GetAttribute("AmmoCapacity")
    self.Instance:SetAttribute("Reloading", true)
    local reloadSound = self.reloadSoundTemplate:Clone()
    reloadSound.Parent = self.reloadSoundTemplate.Parent
    reloadSound:Play()
    Promise.delay(reloadTime):andThen(function()
        self.Instance:SetAttribute("Ammo", ammoCapacity)
        self.Instance:SetAttribute("Reloading", false)
        reloadSound:Destroy()
    end)
end

function component:createShotEffect(shotResult: RaycastResult)
    if not shotResult then return end
    local hitPlayer = self:getHumanoidFromPart(shotResult.Instance) ~= nil
    local effectPart = Instance.new("Part")
    effectPart.Parent = workspace
    effectPart.Anchored = true
    effectPart.CanCollide = false
    effectPart.Transparency = 1
    effectPart.Size = Vector3.new(0.2, 0.2, 0.2)
    effectPart.CFrame = CFrame.new(shotResult.Position, shotResult.Position + shotResult.Normal) * CFrame.new(0, 0, 0.1)
    -- Particle emitter
    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Parent = effectPart
    particleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    particleEmitter.Lifetime = NumberRange.new(0.5, 1)
    particleEmitter.Size = NumberSequence.new(0.1)
    particleEmitter.Acceleration = Vector3.new(0, -9.81, 0)
    particleEmitter.EmissionDirection = Enum.NormalId.Front
    particleEmitter.Rate = 0
    particleEmitter.SpreadAngle = Vector2.new(45, 45)
    particleEmitter.Color =
        if hitPlayer
        then ColorSequence.new(Color3.fromRGB(255, 0, 0))
        else ColorSequence.new(shotResult.Instance.Color)
    particleEmitter:Emit(10)
    if self.muzzleFlashEmitter then
        self.muzzleFlashEmitter:Emit(3)
    end
    if self.muzzleFlashLight then
        self.muzzleFlashLight.Enabled = true
        Promise.delay(0.1):andThen(function()
            self.muzzleFlashLight.Enabled = false
        end)
    end
    -- Shot decal
    if not hitPlayer then
        local decal = Instance.new("Decal")
        decal.Parent = effectPart
        decal.Texture = "rbxassetid://12845865907"
        decal.Face = Enum.NormalId.Front
    end
    Debris:AddItem(effectPart, 50)
end

function component:getBulletOrigin()
    return self.bulletOrigin.WorldCFrame.Position
end

function component:getShotResult(from: Vector3, at: Vector3, player: Player)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.CollisionGroup = "CameraRaycast"
    raycastParams.FilterDescendantsInstances = { player.Character }
    return workspace:Raycast(
        from,
        (at - from).Unit * self.Instance:GetAttribute("MaxRange"),
        raycastParams
    )
end

function component:getHumanoidFromPart(part: BasePart)
    local character = part:FindFirstAncestorOfClass("Model")
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid
end

function component:getDamageFromRange(range: number)
    local maxRange = self.Instance:GetAttribute("MaxRange")
    local lethalRange = self.Instance:GetAttribute("LethalRange")
    local damage = self.Instance:GetAttribute("Damage")
    if range <= lethalRange then
        return self.Instance:GetAttribute("Damage")
    else
        local distanceRange = maxRange - lethalRange
        local rangeBeyondLethal = range - lethalRange
        return damage * (1 - (rangeBeyondLethal / distanceRange))
    end
end

function component:setUpAnimations()
    local humanoid = self.Instance.Parent:WaitForChild("Humanoid", 1)
    if not humanoid then return end
    local animator = humanoid:WaitForChild("Animator", 1)
    if not animator then return end
    self.aimAnimationTrack = animator:LoadAnimation(self.aimAnimation)
    self.aimAnimationTrack.Looped = true
    self.aimAnimationTrack:Play()
    self.Instance.Unequipped:Connect(function()
        self.aimAnimationTrack:Stop()
    end)
end

return component