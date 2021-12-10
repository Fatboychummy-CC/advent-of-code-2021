-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

-- Collect all positions of the crab submarines. We'll want to determine min and max position
local positions = {n = 0}
local min, max = math.huge, -math.huge
for position in data[1]:gmatch("%d+") do
  -- convert to number
  position = tonumber(position)

  -- insert into positions list
  positions.n = positions.n + 1
  positions[positions.n] = position

  -- check for min and max values

  if position > max then
    max = position
  elseif position < min then
    min = position
  end
end

-- loop through min to max.
local minDiff = math.huge
local minPos = 0
for i = min, max do
  -- sum the difference between position i and the positions of the
  local sum = 0
  for j = 1, positions.n do
    -- use fancy mathematics (sum[1->n] = n(n + 1)/2)
    local n = math.abs(positions[j] - i)
    sum = sum + (n * (n + 1) / 2)
    if sum > minDiff then break end
  end
  if sum < minDiff then
    minDiff = sum
    minPos = i
  end
end

print("By moving the crabs to position", minPos, "we will use the minimum amount of fuel (", minDiff, ")")
finalOutput(minDiff)
output(tostring(minDiff))

finalize()
