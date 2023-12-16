local TableUtil = require(script.Parent.Parent.TableUtil)

local filter = {}

function filter.process(instances, filt)
    if not filt then
        return instances
    end
    instances = TableUtil.Filter(instances, function(instance)
        if filt.tag and not instance:HasTag(filt.tag) then
            return false
        end
        if filt.className and instance.ClassName ~= filt.className then
            return false
        end
        if filt.name and instance.Name ~= filt.name then
            return false
        end
        if filt.attributes then
            for attributeName, attributeValue in filt.attributes do
                if instance:GetAttribute(attributeName) ~= attributeValue then
                    return false
                end
            end
        end
        return true
    end)
    return instances
end

return filter