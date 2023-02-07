# retry-with-delay

Utility function for pcalling and retrying a function multiple times.

```lua
local success, result = retryWithDelay(
	getPlayerData, -- function to call
	3, -- maximum retries
	1, -- seconds between each attempt
	234534 -- argument(s) to be passed to the function
)

if success then
	print(result)
else
	print("It didn't work: " .. result)
end
```