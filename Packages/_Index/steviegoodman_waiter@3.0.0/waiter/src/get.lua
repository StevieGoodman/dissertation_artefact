local Custodian = require(script.Parent.Parent.Custodian)
local Filter = require(script.Parent.filter)

local get = {}

function get.children(origin, filter)
    local children = origin:GetChildren()
    children = Filter.process(children, filter)
    if #children == 0 then
        return Custodian.option.none()
    else
        return Custodian.option.new(children)
    end
    return children
end

function get.child(origin, filter)
    local optionObj = get.children(origin, filter)
    local result = Custodian.option.isSomeThen(optionObj, function(children)
        return children[1]
    end)
    return Custodian.option.new(result)
end

function get.descendants(origin, filter)
    local descendants = origin:GetDescendants()
    descendants = Filter.process(descendants, filter)
    if #descendants == 0 then
        return Custodian.option.none()
    else
        return Custodian.option.new(descendants)
    end
    return descendants
end

function get.descendant(origin, filter)
    local optionObj = get.descendants(origin, filter)
    local result = Custodian.option.isSomeThen(optionObj, function(descendants)
        return descendants[1]
    end)
    return Custodian.option.new(result)
end

function get.ancestors(origin, filter)
    local ancestors = {}
    local current = origin
    while current.Parent ~= game do
        current = current.Parent
        table.insert(ancestors, current)
    end
    ancestors = Filter.process(ancestors, filter)
    if #ancestors == 0 then
        return Custodian.option.none()
    else
        return Custodian.option.new(ancestors)
    end
    return ancestors
end

function get.ancestor(origin, filter)
    local optionObj = get.ancestors(origin, filter)
    local result = Custodian.option.isSomeThen(optionObj, function(ancestors)
        return ancestors[1]
    end)
    return Custodian.option.new(result)
end

function get.siblings(origin, filter)
    local optionObj = get.children(origin.Parent, filter)
    local result = Custodian.option.isSomeThen(optionObj, function(children)
        local index = table.find(children, origin)
        if index then
            table.remove(children, index)
            if #children == 0 then
                children = nil
            end
        end
        return Custodian.option.new(children)
    end)
    return result or Custodian.option.none()
end

function get.sibling(origin, filter)
    local optionObj = get.siblings(origin, filter)
    local result = Custodian.option.isSomeThen(optionObj, function(siblings)
        return siblings[1]
    end)
    return Custodian.option.new(result)
end

return get