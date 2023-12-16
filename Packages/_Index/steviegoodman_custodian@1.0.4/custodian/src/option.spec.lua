local Option = require(script.Parent.option)

return function()
    local someOption = Option.new(1)
    local nilOption = Option.new(nil)
    local noneOption = Option.none()

    describe("new() & none()", function()
        it("should create a new Option object", function()
            expect(someOption.value).to.equal(1)
            expect(nilOption.value).to.equal(nil)
            expect(noneOption.value).to.equal(nil)
        end)
    end)

    describe("isSome()", function()
        it("should return true when passed an Option.some", function()
            expect(Option.isSome(someOption)).to.be.equal(true)
        end)
        it("should return false when passed an Option.none", function()
            expect(Option.isSome(noneOption)).to.be.equal(false)
        end)
    end)

    describe("isNone()", function()
        it("should return false when passed an Option.some", function()
            expect(Option.isNone(someOption)).to.be.equal(false)
        end)
        it("should return true when passed an Option.none", function()
            expect(Option.isNone(noneOption)).to.be.equal(true)
        end)
    end)

    describe("isSomeThen()", function()
        it("should call the passed callback when passed an Option.some", function()
            local called = false
            Option.isSomeThen(someOption, function()
                called = true
            end)
            expect(called).to.be.equal(true)
        end)
        it("should not call the passed callback when passed an Option.none", function()
            local called = false
            Option.isSomeThen(noneOption, function()
                called = true
            end)
            expect(called).to.be.equal(false)
        end)
        it("should pass the wrapped value into the passed callback when passed an Option.some", function()
            local value = "no value"
            Option.isSomeThen(someOption, function(val)
                value = val
            end)
            expect(value).to.be.equal(1)
        end)
        it("should not pass the wrapped value into the passed callback when passed an Option.none", function()
            local value = "no value"
            Option.isSomeThen(noneOption, function(val)
                value = val
            end)
            expect(value).to.be.equal("no value")
        end)
        it("should pass in extra arguments into the passed callback", function()
            local string = "no value"
            Option.isSomeThen(someOption, function(_, arg1, arg2, arg3)
                string = `{tostring(arg1)} {arg2} {tostring(arg3)}`
            end, 1, "hello", true)
            expect(string).to.be.equal("1 hello true")
        end)
    end)

    describe("isSomeThenCall()", function()
        it("should call the passed callback when passed an Option.some", function()
            local called = false
            Option.isSomeThenCall(someOption, function()
                called = true
            end)
            expect(called).to.be.equal(true)
        end)
        it("should not call the passed callback when passed an Option.none", function()
            local called = false
            Option.isSomeThenCall(noneOption, function()
                called = true
            end)
            expect(called).to.be.equal(false)
        end)
        it("should pass in extra arguments into the passed callback", function()
            local string = "no value"
            Option.isSomeThenCall(someOption, function(arg1, arg2, arg3)
                string = `{tostring(arg1)} {arg2} {tostring(arg3)}`
            end, 1, "hello", true)
            expect(string).to.be.equal("1 hello true")
        end)
    end)

    describe("isNoneThenCall()", function()
        it("should not call the passed callback when passed an Option.some", function()
            local called = false
            Option.isNoneThenCall(someOption, function()
                called = true
            end)
            expect(called).to.be.equal(false)
        end)
        it("should call the passed callback when passed an Option.none", function()
            local called = false
            Option.isNoneThenCall(noneOption, function()
                called = true
            end)
            expect(called).to.be.equal(true)
        end)
        it("should pass in extra arguments into the passed callback", function()
            local string = "no value"
            Option.isNoneThenCall(noneOption, function(arg1, arg2, arg3)
                string = `{tostring(arg1)} {arg2} {tostring(arg3)}`
            end, 1, "hello", true)
            expect(string).to.be.equal("1 hello true")
        end)
    end)

    describe("switch()", function()
        local switchTable = {
            some = "some",
            none = "none",
        }

        it("should return the some key's value when passed an Option.some", function()
            local value = Option.switch(someOption, switchTable)
            expect(value).to.be.equal("some")
        end)
        it("should return the none key's value when passed an Option.none", function()
            local value = Option.switch(noneOption, switchTable)
            expect(value).to.be.equal("none")
        end)
    end)

    describe("switchThenCall()", function()
        local switchTable = {
            some = function(arg1, arg2, arg3)
                if arg1 and arg2 and arg3 then
                    return "args"
                else
                    return "some"
                end
            end,
            none = function(arg1, arg2, arg3)
                if arg1 and arg2 and arg3 then
                    return "args"
                else
                    return "none"
                end
            end,
        }

        it("should return the some key's returned value when passed an Option.some", function()
            local value = Option.switchThenCall(someOption, switchTable)
            expect(value).to.be.equal("some")
        end)
        it("should return the none key's returned value when passed an Option.none", function()
            local value = Option.switchThenCall(noneOption, switchTable)
            expect(value).to.be.equal("none")
        end)
        it("should pass extra arguments into the passed callbacks", function()
            local someValue = Option.switchThenCall(someOption, switchTable, 1, "hello", true)
            local noneValue = Option.switchThenCall(noneOption, switchTable, 1, "hello", true)
            expect(someValue).to.be.equal("args")
            expect(noneValue).to.be.equal("args")
        end)
    end)

    describe("expect()", function()
        it("should return the wrapped value when passed an Option.some", function()
            local value = Option.expect(someOption)
            expect(value).to.be.equal(1)
        end)

        it("should error when passed an Option.none", function()
            local fn = function()
                Option.expect(noneOption)
            end
            expect(fn).to.throw("Called custodian.option.expect() on custodian.option.none!")
        end)
    end)

    describe("expectThen()", function()
        it("should call the passed callback when passed an Option.some", function()
            local value = Option.expectThen(someOption, function(val)
                return val
            end)
            expect(value).to.be.equal(1)
        end)

        it("should error when passed an Option.none", function()
            local fn = function()
                Option.expect(noneOption)
            end
            expect(fn).to.throw("Called custodian.option.expect() on custodian.option.none!")
        end)
    end)
end