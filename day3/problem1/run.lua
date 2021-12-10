new()

local data = input()

local common = {}

print("Starting on", data.n, "inputs.")
-- Count how common each bit is.
for i = 1, data.n do
  local n = 0
  for c in string.gmatch(data[i], '.') do
    n = n + 1
    if not common[n] then
      common[n] = {["1"] = 0, ["0"] = 0}
    end
    common[n][c] = common[n][c] + 1
  end
end
print("Got", #common, "bits.")

-- Determine both the gamma and epsilon.
local gamma, epsilon = "", ""
for i = 1, #common do
  if common[i]["1"] > common[i]["0"] then
    gamma = gamma .. '1'
    epsilon = epsilon .. '0'
  else
    gamma = gamma .. '0'
    epsilon = epsilon .. '1'
  end
end

local result = tonumber(gamma, 2) * tonumber(epsilon, 2)
print()
print(gamma)
print("x")
print(epsilon)
print("----------")
print(result)
finalOutput(result)
output(result)

finalize()
