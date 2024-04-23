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
    self.aimAnimation = Waiter.get.child(self.Instance, "AimAnimation")
    assert(self.aimAnimation, "AimAnimation not found!")
end

function component:Start()
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
    self:setUpAnimations()
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

function component:setUpAnimations()
    local character = PLAYER.Character
    if not character then return end
    local animator = character.Humanoid.Animator
    if not animator then return end
    self.aimAnimationTrack = animator:LoadAnimation(self.aimAnimation)
    self.aimAnimationTrack.Looped = true
    self.aimAnimationTrack:Play()
    self.Instance.Unequipped:Connect(function()
        self.aimAnimationTrack:Stop()
    end)
end

function component:tryFire()
    if self.Instance:GetAttribute("Ammo") <= 0 then return end
    self:fire()
end

function component:fire()
    local mousePosition = self:getMousePosition()
    if not mousePosition then return end
    Knit.GetService("Gun"):fire(mousePosition)
    local fireTime = os.clock()
    local connection = RunService.RenderStepped:Connect(function(deltaTime)
        local random = Random.new()
        self:updateRecoil(fireTime, deltaTime, random)
    end)
    task.wait(self.Instance:GetAttribute("RecoilDuration") or 0.25)
    connection:Disconnect()
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
    local deltaVector = Vector3.new(
        deltaRecoil * math.rad(random:NextNumber(2.4, 1.6)),
        deltaRecoil * math.rad(random:NextNumber(-1, 1)),
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

return component