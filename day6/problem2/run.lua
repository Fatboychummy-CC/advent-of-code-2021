-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

-- load all the numbers.
local fish = {n = 0}
for time in data[1]:gmatch("%d+") do
  fish.n = fish.n + 1
  fish[fish.n] = tonumber(time)
end

-- Initialize day as 0 since we will immediately increment
local ages = {0, 0, 0, 0, 0, 0, 0, 0, 0}

-- initialize the values of the fish.
for i = 1, fish.n do
  ages[fish[i] + 1] = ages[fish[i] + 1] + 1
end

-- and run the loop.
local totalDays = 256
for _ = 1, totalDays do
  -- each fish on this day will cause a new fish to spawn in 8 days, mark them to be inserted after next day.
  local nextInsertion = ages[1]

  -- Move the list back, bringing the "next day"
  for age = 2, 9 do
    ages[age - 1] = ages[age]
  end

  -- move the current amount of fishes to index 7 (a week later)
  ages[7] = ages[7] + nextInsertion

  -- add the new fish that have spawned at the very end of the list.
  ages[9] = nextInsertion
end

-- sum up all the fish
local sum = 0
for i = 1, 9 do
  sum = sum + ages[i]
end

print("After", totalDays, "days, there are", sum, "total Lanternfish.")

output(tostring(sum))

finalize()
