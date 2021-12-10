new()

local data = input()

local x, y = 0, 0

-- define a hashmap of functions that will be called based on input.
-- i am lazy
local funcs = setmetatable({
  forward = function(n)
    x = x + n
  end,
  down = function(n)
    y = y + n
  end,
  up = function(n)
    y = y - n
  end
}, {__index = function(_, index) error("Unknown input:" .. tostring(index)) end})

-- for each, grab the direction of movement and the count, then run the appropriate func.
for i = 1, data.n do
  local name, num = data[i]:match("^(.+) (%d+)$")
  funcs[name](tonumber(num))
end

print("Finished, got", tostring(x * y))
finalOutput(x * y)
output(tostring(x * y))

finalize()
