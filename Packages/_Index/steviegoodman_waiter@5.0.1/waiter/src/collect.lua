local Get = require(script.Parent.get)

local collect = {}

function collect._process(origin, tags, collectFunc)
    local results = {}
    for index, tag in tags do
        local result = collectFunc(origin, tag)
        if #result == 1 then
            results[index] = result[1]
        else
            results[index] = result
        end
    end
    return results
end

function collect.children(origin, tags)
    return collect._process(origin, tags, Get.children)
end

function collect.descendants(origin, tags)
    return collect._process(origin, tags, Get.descendants)
end

function collect.ancestors(origin, tags)
    return collect._process(origin, tags, Get.ancestors)
end

function collect.siblings(origin, tags)
    return collect._process(origin, tags, Get.siblings)
end

return collect