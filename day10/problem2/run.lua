-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

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
  end,

  -- This returns a list of closers that will complete the stack.
  Complete = function(self)
    local completion = {n = 0}

    for i = self.n, 1, -1 do
      completion.n = completion.n + 1

      -- determine which opener was used
      local y = getID(self[i])
      -- add the closer to the list.
      completion[completion.n] = keys[y][2]
    end

    return completion
  end
}


-- initialize a list of valid line completions
local valid = {n = 0, Insert = function(self, v) self.n = self.n + 1 self[self.n] = v end}

-- for each input line
for i = 1, data.n do
  -- clear stack
  stack:Clear()

  local isValid = true

  -- for each character in the string
  for char in data[i]:gmatch(".") do
    -- try to insert the string
    if not stack:TryInsert(char) then
      -- if it fails, mark it
      isValid = false
      break
    end
  end

  if isValid then
    valid:Insert(stack:Complete())
  end
end

local pointMap = {
  [')'] = 1,
  [']'] = 2,
  ['}'] = 3,
  ['>'] = 4
}

if valid.n % 2 == 0 then
  error("Got an even number of incomplete lines. This should not happen.", 0)
end

-- for each valid closer, get the score.
for i = 1, valid.n do
  local sum = 0
  for j = 1, valid[i].n do
    sum = sum * 5 + pointMap[valid[i][j]]
  end

  valid[i] = sum
end

-- sort the table
table.sort(valid)

-- compute the middle value
local middle = math.ceil(valid.n / 2)

print("Minimum:", valid[1])
print("Middle :", valid[middle])
print("Maximum:", valid[valid.n])

-- output
finalOutput(valid[middle])
output(tostring(valid[middle]))

finalize()
