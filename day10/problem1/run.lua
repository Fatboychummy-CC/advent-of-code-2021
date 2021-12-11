-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

local pointMap = {
  [')'] = 3,
  [']'] = 57,
  ['}'] = 1197,
  ['>'] = 25137
}

local keys = {
  {"(", ")"},
  {"[", "]"},
  {"{", "}"},
  {"<", ">"}
}

local function getID(thing)
  for i = 1, 4 do
    for j = 1, 2 do
      if keys[i][j] == thing then
        return i, j
      end
    end
  end
end

local stack = {
  n = 0,
  -- TryInsert function attempts to insert something into the stack
  -- returns true if succeeded, false if it failed.
  TryInsert = function(self, value)
    local i, j = getID(value)
    if j == 1 then
      self.n = self.n + 1
      self[self.n] = value
      return true
    else
      -- closer, make sure the closer matches the opener
      if self[self.n] == keys[i][1] then
        -- all is good, remove it from the stack.
        self[self.n] = nil
        self.n = self.n - 1
        return true
      else
        -- we did not find a matching opener in the list.
        return false
      end
    end
  end,

  -- Simply clears the stack.
  Clear = function(self)
    for i = 1, self.n do
      self[i] = nil
    end
    self.n = 0
  end
}

-- initialize hashmap of counts for each type of closer that is missing.
local counts = {
  [')'] = 0,
  [']'] = 0,
  ['}'] = 0,
  ['>'] = 0
}
-- for each input line
for i = 1, data.n do
  -- clear stack
  stack:Clear()

  -- for each character in the string
  for char in data[i]:gmatch(".") do
    -- try to insert the string
    if not stack:TryInsert(char) then
      -- if it fails, increase count variable.
      counts[char] = counts[char] + 1
      break
    end
  end
end

-- determine output data
local sum = 0
for k, v in pairs(counts) do
  print(pointMap[k], v)
  sum = sum + pointMap[k] * v
end

-- output
finalOutput(sum)
output(tostring(sum))

finalize()
