new()

local data = input()
print("Checking", data.n, "lines.")

local newData = {n = 0}

-- read file into "sliding window"
for i = 1, data.n - 2 do
  -- start a sum
  local sum = 0
  -- for the next 3 items
  for j = 0, 2 do
    -- add to the sum
    sum = sum + data[i + j]
  end

  -- add sum to the list
  newData.n = newData.n + 1
  newData[newData.n] = sum
end

print("Finished first check.")

print("Checking", newData.n, "entries.")

local last = math.huge
local count = 0

for i = 1, newData.n do
  if last < tonumber(newData[i]) then
    count = count + 1
  end

  last = tonumber(newData[i])
end

print("Finished, got:", count)
output(tostring(count))

--

finalize()
