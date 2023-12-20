local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local component = Component.new {
    Tag = "ProgressBar",
}

local LOW_COLOR = Color3.fromRGB(212, 34, 34)
local HIGH_COLOR = Color3.fromRGB(40, 205, 65)

function component:Start()
    self.Instance:SetAttribute("Progress", 100)
    self.Instance:GetAttributeChangedSignal("Progress"):Connect(function()
        self:UpdateProgress(self.Instance:GetAttribute("Progress"))
    end)
end

function component:UpdateProgress(newValue: number)
    self.Instance.Size = UDim2.new(newValue / 100, 0, 1, 0)
    local barColor = Color3.new(
        LOW_COLOR.R + (HIGH_COLOR.R - LOW_COLOR.R) * (newValue / 100),
        LOW_COLOR.G + (HIGH_COLOR.G - LOW_COLOR.G) * (newValue / 100),
        LOW_COLOR.B + (HIGH_COLOR.B - LOW_COLOR.B) * (newValue / 100)
    )
    self.Instance.BackgroundColor3 = barColor
end

return component