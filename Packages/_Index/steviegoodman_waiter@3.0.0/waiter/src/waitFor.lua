local Custodian = require(script.Parent.Parent.Custodian)
local Get = require(script.Parent.get)

local waitFor = {}

function waitFor._process(duration, origin, filter, getFn)
    local startTime = os.time()
    local optionObj = nil
    repeat
        optionObj = getFn(origin, filter)
        task.wait()
    until os.time() - startTime > duration or Custodian.option.isSome(optionObj)
    return Custodian.option.new(optionObj.value)
end

function waitFor.child(duration, origin, filter)
    return waitFor._process(duration, origin, filter, Get.child)
end

function waitFor.descendant(duration, origin, filter)
    return waitFor._process(duration, origin, filter, Get.descendant)
end

function waitFor.sibling(duration, origin, filter)
    return waitFor._process(duration, origin, filter, Get.sibling)
end

return waitFor