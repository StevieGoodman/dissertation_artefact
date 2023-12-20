local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)

local component = Component.new {
    Tag = "ProgressBar",
}

function component:Start()
    self.Instance:SetAttribute("Progress", 100)
    self.Instance:GetAttributeChangedSignal("Progress"):Connect(function()
        self:UpdateProgress(self.Instance:GetAttribute("Progress"))
    end)
end

function component:UpdateProgress(newValue: number)
    self.Instance.Size = UDim2.new(newValue / 100, 0, 1, 0)
end

return component