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

-- and run the loop.
for _ = 1, 80 do
  -- iterate through each fish, backwards. New fish will be inserted at the end so we don't want to run over them.
  for i = fish.n, 1, -1 do
    if fish[i] == 0 then
      fish[i] = 7
      fish.n = fish.n + 1
      fish[fish.n] = 8
    end

    fish[i] = fish[i] - 1
  end
end

print("After 80 days, there are", fish.n, "total Lanternfish.")
finalOutput(fish.n)
output(tostring(fish.n))

finalize()
