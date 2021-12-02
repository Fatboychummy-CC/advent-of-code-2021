new()

local data = input()

local x, y, aim = 0, 0, 0

local funcs = setmetatable({
  forward = function(n)
    x = x + n
    y = y + (aim * n) -- this changes
  end,
  down = function(n)
    --y = y + n -- this changes
    aim = aim + n -- this changes
  end,
  up = function(n)
    --y = y - n -- this changes
    aim = aim - n -- this changes
  end
}, {__index = function(_, index) error("Unknown input:" .. tostring(index)) end})

for i = 1, data.n do
  local name, num = data[i]:match("^(.+) (%d+)$")
  funcs[name](tonumber(num))
end

print("Finished, got", tostring(x * y))
output(tostring(x * y))

finalize()
