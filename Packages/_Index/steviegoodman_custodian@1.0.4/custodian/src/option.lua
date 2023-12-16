local option = {}

function option.new(val)
    return { value = val }
end

function option.none()
    return option.new(nil)
end

function option.isSome(optionObj)
    return optionObj.value ~= nil
end

function option.isNone(optionObj)
    return not option.isSome(optionObj)
end

function option.isSomeThen(optionObj, callback, ...)
    if option.isSome(optionObj) then
        return callback(optionObj.value, ...)
    end
end

function option.isSomeThenCall(optionObj, callback, ...)
    if option.isSome(optionObj) then
        return callback(...)
    end
end

function option.isNoneThenCall(optionObj, callback, ...)
    if option.isNone(optionObj) then
        return callback(...)
    end
end

function option.switch(optionObj, switchTable)
    if option.isSome(optionObj) then
        return switchTable.some
    else
        return switchTable.none
    end
end

function option.switchThenCall(optionObj, switchTable, ...)
    local result = nil
    result = option.isSomeThenCall(optionObj, switchTable.some, ...)
    -- Prevents isNoneThenCall from overwriting non-nil result
    if result then
        return result
    end
    result = option.isNoneThenCall(optionObj, switchTable.none, ...)
    return result
end

function option.expect(optionObj)
    if option.isNone(optionObj) then
        error("Called custodian.option.expect() on custodian.option.none!")
    end
    return optionObj.value
end

function option.expectThen(optionObj, callback, ...)
    option.expect(optionObj)
    return callback(optionObj.value, ...)
end

return option