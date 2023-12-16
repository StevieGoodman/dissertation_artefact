local Filter = require(script.Parent.filter)

local get = {}

function get._process(origin, filter, getFunc)
    local results = getFunc(origin)
    return Filter.process(results, filter)
end

function get.children(origin, filter)
    return get._process(origin, filter, origin.GetChildren)
end

function get.child(origin, filter)
    local children = get.children(origin, filter)
    return children[1]
end

function get.descendants(origin, filter)
    return get._process(origin, filter, origin.GetDescendants)
end

function get.descendant(origin, filter)
    local descendants = get.descendants(origin, filter)
    return descendants[1]
end

function get.ancestors(origin, filter)
    local ancestors = {}
    local current = origin
    while current.Parent ~= game do
        current = current.Parent
        table.insert(ancestors, current)
    end
    return Filter.process(ancestors, filter)
end

function get.ancestor(origin, filter)
    local ancestors = get.ancestors(origin, filter)
    return ancestors[1]
end

function get.siblings(origin, filter)
    -- Prevents attempting to index game's parent
    if origin == game then
        return {}
    else
        local siblings = get._process(origin.Parent, filter, origin.Parent.GetChildren)
        -- Removes the origin from the siblings if applicable
        local originIndex = table.find(siblings, origin)
        if originIndex then
            table.remove(siblings, originIndex)
        end
        return siblings
    end
end

function get.sibling(origin, filter)
    local siblings = get.siblings(origin, filter)
    return siblings[1]
end

return get