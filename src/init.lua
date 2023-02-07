local ReplicatedStorage = game:GetService("ReplicatedStorage")

local packages = ReplicatedStorage.Packages
local t = require(packages.t)

local function retryWithDelay(callback, maxRetries, timeDelay, ...)
	assert(t.callback(callback))
	assert(t.integer(maxRetries))
	assert(t.number(timeDelay))
	local args = {...}
	local attempt = 0
	local success, result

	repeat
		attempt += 1
		success, result = pcall(callback, unpack(args))
		if not success and attempt < maxRetries then
			task.wait(timeDelay)
		end
	until success or attempt == maxRetries

	return success, result
end

return retryWithDelay