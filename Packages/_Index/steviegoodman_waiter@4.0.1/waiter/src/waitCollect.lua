local WaitFor = require(script.Parent.waitFor)

local waitCollect = {}

function waitCollect._process(origin, filters, waitCollectFunc, relationName, duration)
    local results = {}
    for index, filter in filters do
        local result = waitCollectFunc(origin, filter, duration)
        if result then
            results[index] = result
        else
            error(`Unable to collect all {relationName}!\nOrigin: {origin:GetFullName()}\nFilter Name: {filter.Name}\nFilter Class: {filter.ClassName}`)
        end
    end
    return results
end

function waitCollect.children(origin, filters, duration)
    return waitCollect._process(origin, filters, WaitFor.child, "children", duration)
end

function waitCollect.descendants(origin, filters, duration)
    return waitCollect._process(origin, filters, WaitFor.descendant, "descendants", duration)
end

function waitCollect.siblings(origin, filters, duration)
    return waitCollect._process(origin, filters, WaitFor.sibling, "siblings", duration)
end

return waitCollect