local Result = require(script.Parent.result)

return function()
    local okResult = Result.ok("ok")
    local errResult = Result.err("err")

    describe("ok() & err()", function()
        it("should create a new Result object", function()
            expect(okResult.ok).to.equal("ok")
            expect(okResult.err).to.equal(nil)
            expect(errResult.err).to.equal("err")
            expect(errResult.ok).to.equal(nil)
        end)
    end)

    describe("isOk()", function()
        it("should return true when passed an Result.ok", function()
            expect(Result.isOk(okResult)).to.be.equal(true)
        end)
        it("should return false when passed an Result.err", function()
            expect(Result.isOk(errResult)).to.be.equal(false)
        end)
    end)

    describe("isErr()", function()
        it("should return false when passed an Result.ok", function()
            expect(Result.isErr(okResult)).to.be.equal(false)
        end)
        it("should return true when passed an Result.err", function()
            expect(Result.isErr(errResult)).to.be.equal(true)
        end)
    end)

    describe("isOkThen()", function()
        it("should call the passed callback when passed an Result.ok", function()
            local called = false
            Result.isOkThen(okResult, function()
                called = true
            end)
            expect(called).to.be.equal(true)
        end)
        it("should not call the passed callback when passed an Result.err", function()
            local called = false
            Result.isOkThen(errResult, function()
                called = true
            end)
            expect(called).to.be.equal(false)
        end)
        it("should pass the wrapped value into the passed callback when passed an Result.ok", function()
            local value = "no value"
            Result.isOkThen(okResult, function(val)
                value = val
            end)
            expect(value).to.be.equal("ok")
        end)
        it("should not pass the wrapped value into the passed callback when passed an Result.err", function()
            local value = "no value"
            Result.isOkThen(errResult, function(val)
                value = val
            end)
            expect(value).to.be.equal("no value")
        end)
        it("should pass in extra arguments into the passed callback", function()
            local string = "no value"
            Result.isOkThen(okResult, function(_, arg1, arg2, arg3)
                string = `{tostring(arg1)} {arg2} {tostring(arg3)}`
            end, 1, "hello", true)
            expect(string).to.be.equal("1 hello true")
        end)
    end)

    describe("isErrThen()", function()
        it("should not call the passed callback when passed an Result.ok", function()
            local called = false
            Result.isErrThen(okResult, function()
                called = true
            end)
            expect(called).to.be.equal(false)
        end)
        it("should call the passed callback when passed an Result.err", function()
            local called = false
            Result.isErrThen(errResult, function()
                called = true
            end)
            expect(called).to.be.equal(true)
        end)
        it("should not pass the wrapped value into the passed callback when passed an Result.ok", function()
            local value = "no value"
            Result.isErrThen(okResult, function(val)
                value = val
            end)
            expect(value).to.be.equal("no value")
        end)
        it("should pass the wrapped value into the passed callback when passed an Result.err", function()
            local value = "no value"
            Result.isErrThen(errResult, function(val)
                value = val
            end)
            expect(value).to.be.equal("err")
        end)
        it("should pass in extra arguments into the passed callback", function()
            local string = "no value"
            Result.isErrThen(errResult, function(_, arg1, arg2, arg3)
                string = `{tostring(arg1)} {arg2} {tostring(arg3)}`
            end, 1, "hello", true)
            expect(string).to.be.equal("1 hello true")
        end)
    end)

    describe("isOkThenCall()", function()
        it("should call the passed callback when passed an Result.ok", function()
            local called = false
            Result.isOkThenCall(okResult, function()
                called = true
            end)
            expect(called).to.be.equal(true)
        end)
        it("should not call the passed callback when passed an Result.err", function()
            local called = false
            Result.isOkThenCall(errResult, function()
                called = true
            end)
            expect(called).to.be.equal(false)
        end)
        it("should pass in extra arguments into the passed callback", function()
            local string = "no value"
            Result.isOkThenCall(okResult, function(arg1, arg2, arg3)
                string = `{tostring(arg1)} {arg2} {tostring(arg3)}`
            end, 1, "hello", true)
            expect(string).to.be.equal("1 hello true")
        end)
    end)

    describe("isErrThenCall()", function()
        it("should not call the passed callback when passed an Result.ok", function()
            local called = false
            Result.isErrThenCall(okResult, function()
                called = true
            end)
            expect(called).to.be.equal(false)
        end)
        it("should call the passed callback when passed an Result.err", function()
            local called = false
            Result.isErrThenCall(errResult, function()
                called = true
            end)
            expect(called).to.be.equal(true)
        end)
        it("should pass in extra arguments into the passed callback", function()
            local string = "no value"
            Result.isErrThenCall(errResult, function(arg1, arg2, arg3)
                string = `{tostring(arg1)} {arg2} {tostring(arg3)}`
            end, 1, "hello", true)
            expect(string).to.be.equal("1 hello true")
        end)
    end)

    describe("switch()", function()
        local switchTable = {
            ok = "ok",
            err = "err",
        }

        it("should return the some key's value when passed an Result.ok", function()
            local value = Result.switch(okResult, switchTable)
            expect(value).to.be.equal("ok")
        end)
        it("should return the none key's value when passed an Result.err", function()
            local value = Result.switch(errResult, switchTable)
            expect(value).to.be.equal("err")
        end)
    end)

    describe("switchThen()", function()
        local switchTable = {
            ok = function(arg1, arg2, arg3)
                if arg1 and arg2 and arg3 then
                    return "args"
                else
                    return "ok"
                end
            end,
            err = function(arg1, arg2, arg3)
                if arg1 and arg2 and arg3 then
                    return "args"
                else
                    return "err"
                end
            end,
        }

        it("should return the ok key's returned value when passed an Result.ok", function()
            local value = Result.switchThen(okResult, switchTable)
            expect(value).to.be.equal("ok")
        end)
        it("should return the err key's returned value when passed an Result.err", function()
            local value = Result.switchThen(errResult, switchTable)
            expect(value).to.be.equal("err")
        end)
        it("should pass extra arguments into the passed callbacks", function()
            local okValue = Result.switchThen(okResult, switchTable, 1, "hello", true)
            local errValue = Result.switchThen(errResult, switchTable, 1, "hello", true)
            expect(okValue).to.be.equal("args")
            expect(errValue).to.be.equal("args")
        end)
    end)

    describe("switchThenCall()", function()
        local switchTable = {
            ok = function(arg1, arg2, arg3)
                if arg1 and arg2 and arg3 then
                    return "args"
                else
                    return "ok"
                end
            end,
            err = function(arg1, arg2, arg3)
                if arg1 and arg2 and arg3 then
                    return "args"
                else
                    return "err"
                end
            end,
        }

        it("should return the some key's returned value when passed an Result.ok", function()
            local value = Result.switchThenCall(okResult, switchTable)
            expect(value).to.be.equal("ok")
        end)
        it("should return the none key's returned value when passed an Result.err", function()
            local value = Result.switchThenCall(errResult, switchTable)
            expect(value).to.be.equal("err")
        end)
        it("should pass extra arguments into the passed callbacks", function()
            local okValue = Result.switchThenCall(okResult, switchTable, 1, "hello", true)
            local errValue = Result.switchThenCall(errResult, switchTable, 1, "hello", true)
            expect(okValue).to.be.equal("args")
            expect(errValue).to.be.equal("args")
        end)
    end)

    describe("expectOk()", function()
        it("should return the wrapped value when passed an Result.ok", function()
            local value = Result.expectOk(okResult)
            expect(value).to.be.equal("ok")
        end)

        it("should error when passed an Result.err", function()
            local fn = function()
                Result.expectOk(errResult)
            end
            expect(fn).to.throw("Called custodian.result.expectOk() on custodian.result.err!")
        end)
    end)

    describe("expectOkThen()", function()
        it("should call the passed callback when passed an Result.ok", function()
            local value = Result.expectOkThen(okResult, function(val)
                return val
            end)
            expect(value).to.be.equal("ok")
        end)

        it("should error when passed an Result.err", function()
            local fn = function()
                Result.expectOkThen(errResult)
            end
            expect(fn).to.throw("Called custodian.result.expectOk() on custodian.result.err!")
        end)
    end)

    describe("expectErrThen()", function()
        it("should call the passed callback when passed an Result.err", function()
            local value = Result.expectErrThen(errResult, function(val)
                return val
            end)
            expect(value).to.be.equal("err")
        end)

        it("should error when passed an Result.ok", function()
            local fn = function()
                Result.expectErrThen(okResult)
            end
            expect(fn).to.throw("Called custodian.result.expectErr() on custodian.result.ok!")
        end)
    end)
end