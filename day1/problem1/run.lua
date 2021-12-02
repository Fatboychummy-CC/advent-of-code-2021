new()

local data = input()
print("Checking", data.n, "entries.")

local last = math.huge
local count = 0

-- for each line
for i = 1, data.n do
  -- check if the value is larger than the previous.
  if last < tonumber(data[i]) then
    count = count + 1
  end

  -- assign the previous to the current
  last = tonumber(data[i])
end

print("Finished, got:", count)

output(tostring(count))

finalize()
