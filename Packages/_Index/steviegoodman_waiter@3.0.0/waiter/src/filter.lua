local TableUtil = require(script.Parent.Parent.TableUtil)

local filter = {}

function filter.process(instances, filt)
    if not filt then
        return instances
    end
    instances = TableUtil.Filter(instances, function(instance)
        if filt.Tag and instance:HasTag(filt.Tag) then
            return true
        end
        if filt.ClassName and instance.ClassName == filt.ClassName then
            return true
        end
        if filt.Name and instance.Name == filt.Name then
            return true
        end
        if filt.Attributes then
            for attributeName, attributeValue in filt.Attributes do
                if instance:GetAttribute(attributeName) ~= attributeValue then continue end
                return true
            end
        end
        return false
    end)
    return instances
end

return filter