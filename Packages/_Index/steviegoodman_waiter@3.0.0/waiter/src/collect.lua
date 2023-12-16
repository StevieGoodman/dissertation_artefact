local Custodian = require(script.Parent.Parent.Custodian)
local Get = require(script.Parent.get)

local collect = {}

function collect._process(origin, filters, getFn, relationName)
    local results = {}
    for index, filter in filters do
        local optionObj = getFn(origin, filter)
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

function collect.children(origin, filters)
    return collect._process(origin, filters, Get.child, "children")
end

function collect.descendants(origin, filters)
    return collect._process(origin, filters, Get.descendant, "descendants")
end

function collect.ancestors(origin, filters)
    return collect._process(origin, filters, Get.ancestor, "ancestors")
end

function collect.siblings(origin, filters)
    return collect._process(origin, filters, Get.sibling, "siblings")
end

return collect