return function()
	local retryWithDelay = require(script.Parent)

	describe("retryWithDelay", function()
		it("should retry a failing function", function()
			local shouldFail = true
			local didRetry = false
			local function attempt()
				if shouldFail then
					shouldFail = false
					error("AAAAAAAAAA")
				else
					didRetry = true
				end
			end
			local success, _result = retryWithDelay(attempt, 5, 0)
			expect(success).to.equal(true)
			expect(didRetry).to.equal(true)
		end)

		it("should give up after X retries", function()
			local attempts = 0
			local function attempt()
				attempts += 1
				error("NOP")
			end
			local success, _result = retryWithDelay(attempt, 5, 0)
			expect(success).to.equal(false)
			expect(attempts).to.equal(5)
		end)

		it("should not yield if success on the first attempt", function()
			local didRun = false
			local checkComplete = false
			task.defer(function()
				expect(didRun).to.equal(true)
				checkComplete = true
			end)
			local function attempt()
				didRun = true
			end
			retryWithDelay(attempt, 5, 1)
			repeat task.wait() until checkComplete == true
		end)

		it("should return the result", function()
			local function attempt()
				return 5
			end
			local _success, result = retryWithDelay(attempt, 2, 0)
			expect(result).to.equal(5)
		end)

		it("should pass args to the function", function()
			local val1 = "hi"
			local val2 = "hello"
			local result1
			local result2
			local function attempt(arg1, arg2)
				result1 = arg1
				result2 = arg2
			end
			retryWithDelay(attempt, 2, 0, val1, val2)
			expect(result1).to.equal(val1)
			expect(result2).to.equal(val2)
		end)
	end)
end