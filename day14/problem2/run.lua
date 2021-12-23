-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

-- Quick Insert Table
local QIT_ID = {}
local function checkqit(self)
  if type(self) ~= "table" or self._ID ~= QIT_ID then
    error("Expected ':' when calling method on QIT.", 3)
  end
end
local function QIT()
  return {
    _ID = QIT_ID,
    n = 0,
    Insert = function(self, value)
      checkqit(self)

      self.n = self.n + 1
      self[self.n] = value

      return self
    end
  }
end

local function copy(t)
  local tmp = {}

  for k, v in pairs(t) do
    tmp[k] = v
  end

  return tmp
end

local function readData()
  local polyPairs = {}
  local pairGenerates = {}
  local letterCounts = {}

  -- Read the first line of data into input pairs
  for i = 1, #data[1] - 1 do
    local pair = data[1]:sub(i, i + 1)
    if polyPairs[pair] then
      polyPairs[pair] = polyPairs[pair] + 1
    else
      polyPairs[pair] = 1
    end
  end

  -- populate the letterCounts table
  local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  for char in chars:gmatch(".") do
    letterCounts[char] = 0
  end

  -- Count each initial character
  for i = 1, #data[1] do
    local char = data[1]:sub(i, i)
    letterCounts[char] = letterCounts[char] + 1
  end

  -- Determine what each pair generates.
  for i = 3, data.n do
    local a, b, c = data[i]:match("(.)(.) %-> (.)")
    pairGenerates[a .. b] = {char = c, pair1 = a .. c, pair2 = c .. b}
    if not polyPairs[a .. b] then
      polyPairs[a .. b] = 0
    end
  end

  return polyPairs, pairGenerates, letterCounts
end

-- run one iteration of the polymer cycle
local function iteration(polyPairs, pairGenerates, letterCounts)
  for k, v in pairs(copy(polyPairs)) do
    local generated = pairGenerates[k]
    if generated then
      letterCounts[generated.char] = letterCounts[generated.char] + v

      polyPairs[generated.pair1] = polyPairs[generated.pair1] + v
      polyPairs[generated.pair2] = polyPairs[generated.pair2] + v
    end
    polyPairs[k] = polyPairs[k] - v
  end
end


print("Reading data...")
local polyPairs, pairGenerates, letterCounts = readData()

print("Main loop")

for i = 1, 40 do
  iteration(polyPairs, pairGenerates, letterCounts)
end

print("Finding max and min...")
local max, min = -math.huge, math.huge
local maxC, minC = "", ""
for char, value in pairs(letterCounts) do
  if value > max then
    max = value
    maxC = char
  end
  if value < min and value ~= 0 then
    min = value
    minC = char
  end
end

print("Max:", maxC, max)
print("Min:", minC, min)

finalOutput(max - min)
output(tostring(max - min))
finalize()
