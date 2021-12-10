-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

-- mark some string lengths we are interested in.
local lens = {
  [2] = true,
  [4] = true,
  [3] = true,
  [7] = true
}

-- go through each line, look for strings with length [lens]
local count = 0
for _, line in ipairs(data) do
  local passedBar = false
  for str in line:gmatch("[^ ]+") do
    if str == "|" then passedBar = true end -- skipping the bar first, so we're in the output.
    if passedBar and lens[#str] then
      count = count + 1
    end
  end
end

print("There are", count, "1s, 4s, 7s or 8s in the outputs.")

finalOutput(count)
output(tostring(count))

finalize()
