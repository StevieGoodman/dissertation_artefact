local result = {}

function result.ok(val)
    return { ok = val }
end

function result.err(val)
    return { err = val }
end

function result.isOk(resultObj)
    return resultObj.ok ~= nil
end

function result.isErr(resultObj)
    return resultObj.err ~= nil
end

function result.isOkThen(resultObj, callback, ...)
    if result.isOk(resultObj) then
        return callback(resultObj.ok, ...)
    end
end

function result.isErrThen(resultObj, callback, ...)
    if result.isErr(resultObj) then
        return callback(resultObj.err, ...)
    end
end

function result.isOkThenCall(resultObj, callback, ...)
    if result.isOk(resultObj) then
        return callback(...)
    end
end

function result.isErrThenCall(resultObj, callback, ...)
    if result.isErr(resultObj) then
        return callback(...)
    end
end

function result.switch(resultObj, switchTable)
    if result.isOk(resultObj) then
        return switchTable.ok
    else
        return switchTable.err
    end
end

function result.switchThen(resultObj, switchTable, ...)
    local value = nil
    value = result.isOkThen(resultObj, switchTable.ok, ...)
    if value then
        return value
    end
    value = result.isErrThen(resultObj, switchTable.err, ...)
    return value
end

function result.switchThenCall(resultObj, switchTable, ...)
    local value = nil
    value = result.isOkThenCall(resultObj, switchTable.ok, ...)
    if value then
        return value
    end
    value = result.isErrThenCall(resultObj, switchTable.err, ...)
    return value
end

function result.expectOk(resultObj)
    if result.isErr(resultObj) then
        error("Called custodian.result.expectOk() on custodian.result.err!")
    end
    return resultObj.ok
end

function result.expectErr(resultObj)
    if result.isOk(resultObj) then
        error("Called custodian.result.expectErr() on custodian.result.ok!")
    end
    return resultObj.err
end

function result.expectOkThen(resultObj, callback, ...)
    result.expectOk(resultObj)
    return callback(resultObj.ok, ...)
end

function result.expectErrThen(resultObj, callback, ...)
    result.expectErr(resultObj)
    return callback(resultObj.err, ...)
end

return result