local Filter = require(script.Parent.filter)

local get = {}

function get._process(origin, tag, getFunc)
    local results = getFunc(origin)
    return Filter.process(results, tag)
end

function get.children(origin, tag)
    return get._process(origin, tag, origin.GetChildren)
end

function get.child(origin, tag)
    local children = get.children(origin, tag)
    return children[1]
end

function get.descendants(origin, tag)
    return get._process(origin, tag, origin.GetDescendants)
end

function get.descendant(origin, tag)
    local descendants = get.descendants(origin, tag)
    return descendants[1]
end

function get.ancestors(origin, tag)
    local ancestors = {}
    local current = origin
    while current.Parent ~= game do
        current = current.Parent
        table.insert(ancestors, current)
    end
    return Filter.process(ancestors, tag)
end

function get.ancestor(origin, tag)
    local ancestors = get.ancestors(origin, tag)
    return ancestors[1]
end

function get.siblings(origin, tag)
    -- Prevents attempting to index game's parent
    if origin == game then
        return {}
    else
        local siblings = get._process(origin.Parent, tag, origin.Parent.GetChildren)
        -- Removes the origin from the siblings if applicable
        local originIndex = table.find(siblings, origin)
        if originIndex then
            table.remove(siblings, originIndex)
        end
        return siblings
    end
end

function get.sibling(origin, tag)
    local siblings = get.siblings(origin, tag)
    return siblings[1]
end

return get