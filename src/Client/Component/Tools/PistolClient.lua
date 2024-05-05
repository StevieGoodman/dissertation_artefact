local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Component = require(ReplicatedStorage.Packages.Component)
local Knit = require(ReplicatedStorage.Packages.Knit)

local PLAYER = Players.LocalPlayer
local CAMERA = workspace.CurrentCamera

local component = Component.new {
    Tag = "Pistol",
    Ancestors = { PLAYER }
}

function component:Construct()
    Knit.OnStart():await()
    self.cursorController = Knit.GetController("Cursor")
    self.cameraController = Knit.GetController("Camera")
    self.nextShotTime = 0
end

function component:Start()
    self.Instance.Equipped:Once(function()
        self:onEquip()
        self.activatedConnection = self.Instance.Activated:Connect(function()
            self:tryFire()
        end)
    end)
    self.Instance.Unequipped:Once(function()
        self:onUnequip()
        if not self.activatedConnection then return end
        self.activatedConnection:Disconnect()
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
    local characterAlive = PLAYER.Character and PLAYER.Character.Humanoid.Health > 0
    local cameraType =
        if characterAlive
        then self.cameraController.CameraType.CharacterUnlocked
        else self.cameraController.CameraType.CursorUnlocked
    self.cameraController:setCameraType(cameraType)
    local cursorIcon =
        if characterAlive
        then self.cursorController.CursorIcon.Hidden
        else self.cursorController.CursorIcon.Default
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

return component