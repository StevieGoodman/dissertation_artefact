local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.WaiterV5)

local PLAYER = Players.LocalPlayer
local CAMERA = workspace.CurrentCamera

local component = Component.new {
    Tag = "Pistol",
}

function component:Construct()
    Knit.OnStart():await()
    self.cursorController = Knit.GetController("Cursor")
    self.cameraController = Knit.GetController("Camera")
    self.nextShotTime = 0
    self.aimAnimation = Waiter.get.child(self.Instance, "AimAnimation")
    assert(self.aimAnimation, "AimAnimation not found!")
end

function component:Start()
    self.Instance.Equipped:Connect(function()
        self:setUpAnimations()
    end)
    if not self.Instance:IsDescendantOf(PLAYER)
        and not self.Instance:IsDescendantOf(PLAYER.Character)
        then return end
    self.Instance.Activated:Connect(function()
        self:tryFire()
    end)
    self.Instance.Equipped:Connect(function()
        self:onEquip()
    end)
    self.Instance.Unequipped:Connect(function()
        self:onUnequip()
    end)
end

function component:onEquip()
    self.cursorController:setCursorIcon(self.cursorController.CursorIcon.Simple)
    self.cameraController:setCameraType(self.cameraController.CameraType.CharacterLocked)
    ContextActionService:BindAction("Reload", function(_, inputState, _)
        if inputState == Enum.UserInputState.Begin then
            self:reload()
        end
    end, false, Enum.KeyCode.R)
end

function component:onUnequip()
    local cameraType =
        if PLAYER.Character.Humanoid.Health <= 0
        then self.cameraController.CameraType.CursorUnlocked
        else self.cameraController.CameraType.CharacterUnlocked
    self.cameraController:setCameraType(cameraType)
    local cursorIcon =
        if Players.LocalPlayer.Character.Humanoid.Health <= 0
        then self.cursorController.CursorIcon.Default
        else self.cursorController.CursorIcon.Hidden
    self.cursorController:setCursorIcon(cursorIcon)
    ContextActionService:UnbindAction("Reload")
end

function component:tryFire()
    if self.Instance:GetAttribute("Ammo") <= 0 then return end
    self:fire()
end

function component:fire()
    local mousePosition = self:getMousePosition()
    if not mousePosition then return end
    if not self:canFire() then return end
    Knit.GetService("Gun"):fire(mousePosition)
    local fireTime = os.clock()
    local connection = RunService.RenderStepped:Connect(function(deltaTime)
        local random = Random.new()
        self:updateRecoil(fireTime, deltaTime, random)
    end)
    task.wait(self.Instance:GetAttribute("RecoilDuration") or 0.25)
    connection:Disconnect()
end

function component:canFire()
    if self.Instance:GetAttribute("Ammo") <= 0 then return false end
    if self.Instance:GetAttribute("Reloading") then return false end
    if os.clock() < self.nextShotTime then return false end
    self.nextShotTime = os.clock() + 1 / (self.Instance:GetAttribute("RPM") / 60)
    return true
end

function component:updateRecoil(fireTime, deltaTime, random: Random)
    local duration = self.Instance:GetAttribute("RecoilDuration") or 0.25
    local timeSinceFire = os.clock() - fireTime
    local prevFrameTime = timeSinceFire - deltaTime
    local previousAlpha = prevFrameTime / duration
    local previousRecoil = math.sin(math.pi * previousAlpha)
    local thisAlpha = timeSinceFire / duration
    local thisRecoil = math.sin(math.pi * thisAlpha)
    local deltaRecoil = thisRecoil - previousRecoil
    local verticalMagnitude = math.rad(random:NextNumber(2.4, 1.6))
    local horizontalMagnitude = math.rad(random:NextNumber(-1, 1))
    local deltaVector = Vector3.new(
        deltaRecoil * verticalMagnitude,
        deltaRecoil * horizontalMagnitude,
        0
    )
    CAMERA.CFrame *= CFrame.Angles(deltaVector.X, deltaVector.Y, deltaVector.Z)
end

function component:getMousePosition()
    local position2d = UserInputService:GetMouseLocation()
    local ray = workspace.CurrentCamera:ViewportPointToRay(position2d.X, position2d.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { Players.LocalPlayer.Character }
    local raycastResult = workspace:Raycast(
        ray.Origin,
        ray.Direction * self.Instance:GetAttribute("MaxRange"),
        raycastParams
    )
    if raycastResult then
        return raycastResult.Position
    end
end

function component:reload()
    Knit.GetService("Gun"):reload()
end

function component:setUpAnimations()
    local connection = self.Instance.Parent.Humanoid.Animator.AnimationPlayed:Connect(function(animationTrack)
        if animationTrack.Animation.AnimationId ~= self.aimAnimation.AnimationId then return end
        animationTrack.Looped = true
    end)
    self.Instance.Unequipped:Connect(function()
        connection:Disconnect()
    end)
end

return component