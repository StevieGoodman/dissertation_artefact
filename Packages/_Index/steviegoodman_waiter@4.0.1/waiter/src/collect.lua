local Get = require(script.Parent.get)

local collect = {}

function collect._process(origin, filters, collectFunc, relationName)
    local results = {}
    for index, filter in filters do
        local result = collectFunc(origin, filter)
        if result then
            results[index] = result
        else
            error(`Unable to collect all {relationName}!\nOrigin: {origin:GetFullName()}\nFilter Name: {filter.Name}\nFilter Class: {filter.ClassName}`)
        end
    end
    return results
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