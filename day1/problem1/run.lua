new()

local data = input()
print("Checking", data.n, "entries.")

local last = math.huge
local count = 0

for i = 1, data.n do
  if last < tonumber(data[i]) then
    count = count + 1
  end

  last = tonumber(data[i])
end

print("Finished, got:", count)

output(tostring(count))

finalize()
