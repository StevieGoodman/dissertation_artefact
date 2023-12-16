local Custodian = require(script.Parent.Parent.Custodian)
local WaitFor = require(script.Parent.waitFor)

local waitCollect = {}

function waitCollect._process(duration, origin, filters, getFn, relationName)
    local results = {}
    for index, filter in filters do
        local optionObj = getFn(duration, origin, filter)
        if Custodian.option.isNone(optionObj) then
            return Custodian.result.err(`Unable to collect all {relationName}! Origin: {origin:GetFullName()}, filter: {filter}`)
        else
            Custodian.option.isSomeThen(optionObj, function(instance)
                results[index] = instance
            end)
        end
    end
    return Custodian.result.ok(results)
end

function waitCollect.children(duration, origin, filters)
    return waitCollect._process(duration, origin, filters, WaitFor.child, "children")
end

function waitCollect.descendants(duration, origin, filters)
    return waitCollect._process(duration, origin, filters, WaitFor.descendant, "descendants")
end

function waitCollect.siblings(duration, origin, filters)
    return waitCollect._process(duration, origin, filters, WaitFor.sibling, "siblings")
end

return waitCollect