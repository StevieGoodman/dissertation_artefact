local Get = require(script.Parent.get)

local waitFor = {}

function waitFor._process(origin, filter, getFunc, duration)
    if not duration then
        duration = 1
    end
    local startTime = os.time()
    local result = nil
    repeat
        result = getFunc(origin, filter)
        task.wait()
    until os.time() - startTime > duration or result
    return result
end

function waitFor.child(origin, filter, duration)
    return waitFor._process(origin, filter, Get.child, duration)
end

function waitFor.descendant(origin, filter, duration)
    return waitFor._process(origin, filter, Get.descendant, duration)
end

function waitFor.sibling(origin, filter, duration)
    return waitFor._process(origin, filter, Get.sibling, duration)
end

return waitFor