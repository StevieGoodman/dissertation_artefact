local TableUtil = require(script.Parent.Parent.TableUtil)

local filter = {}

function filter.process(instances, tag)
    if not tag then
        return instances
    else
        return TableUtil.Filter(instances, function(instance)
            return instance:HasTag(tag)
        end)
    end
end

return filter