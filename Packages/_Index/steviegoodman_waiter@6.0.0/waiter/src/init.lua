local TableUtil = require(script.Parent.TableUtil)

export type SearchMode = "Tag" | "ClassName"
type SearchModeFilterFunction = (Instance, string) -> boolean

local SEARCH_MODE_FUNCTIONS = {
    Tag = function(instance, tagQuery)
        return instance:HasTag(tagQuery)
    end,
    ClassName = function(instance, classNameQuery)
        return instance:IsA(classNameQuery)
    end
} :: { SearchModeFilterFunction }

local Waiter = {}

--[[
    Returns a list of all the children that match a query.

    If none are found, an empty table is returned.
]]
function Waiter.getChildren(origin: Instance, query: string?, searchMode: SearchMode?)
    return Waiter.filterInstances(origin, query, origin.GetChildren, searchMode)
end

--[[
    Returns the first child that matches a query.

    If none are found, `nil` is returned.
]]
function Waiter.getChild(origin: Instance, query: string?, searchMode: SearchMode?)
    local children = Waiter.getChildren(origin, query, searchMode)
    return children[1]
end

--[[
    Returns a list of all the descendants that match a query.

    If none are found, an empty table is returned.
]]
function Waiter.getDescendants(origin: Instance, query: string?, searchMode: SearchMode?)
    return Waiter.filterInstances(origin, query, origin.GetDescendants, searchMode)
end

--[[
    Returns the first descendant that matches a query.

    If none are found, `nil` is returned.
]]
function Waiter.getDescendant(origin: Instance, query: string?, searchMode: SearchMode?)
    local descendants = Waiter.getDescendants(origin, query, searchMode)
    return descendants[1]
end

--[[
    Returns a list of all the ancestors that match a query.

    If none are found, an empty table is returned.
]]
function Waiter.getAncestors(origin: Instance, query: string?, searchMode: SearchMode?)
    local function getFn()
        local ancestors = {}
        local current = origin
        while current.Parent ~= game do
            current = current.Parent
            table.insert(ancestors, current)
        end
        return ancestors
    end
    return Waiter.filterInstances(origin, query, getFn, searchMode)
end

--[[
    Returns the first ancestor that matches a query.

    If none are found, `nil` is returned.
]]
function Waiter.getAncestor(origin: Instance, query: string?, searchMode: SearchMode?)
    local ancestors = Waiter.getAncestors(origin, query, searchMode)
    return ancestors[1]
end

--[[
    Returns a list of all siblings that matches a query.

    If none are found, an empty table is returned.
]]
function Waiter.getSiblings(origin: Instance, query: string?, searchMode: SearchMode?)
    -- Prevents attempting to index game's parent
    if origin == game then
        return {}
    else
        local siblings = Waiter.filterInstances(origin.Parent, query, origin.Parent.GetChildren, searchMode)
        -- Removes the origin from the siblings if applicable
        local originIndex = table.find(siblings, origin)
        if originIndex then
            table.remove(siblings, originIndex)
        end
        return siblings
    end
end

--[[
    Returns the first sibling that matches a query.

    If none are found, `nil` is returned.
]]
function Waiter.getSibling(origin: Instance, query: string?, searchMode: SearchMode?)
    local siblings = Waiter.getSiblings(origin, query, searchMode)
    return siblings[1]
end

function Waiter.filterInstances(origin: Instance, query: string?, getFunc, searchMode: SearchMode?)
    local instances = getFunc(origin)
    searchMode = searchMode or "Tag"
    if not query then
        return instances
    else
        return TableUtil.Filter(instances, function(instance)
            return SEARCH_MODE_FUNCTIONS[searchMode](instance, query)
        end)
    end
end

return Waiter