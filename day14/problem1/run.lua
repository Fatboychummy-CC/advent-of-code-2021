-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

local NULL_ROPE = {Concat = function() return "" end}
local _ROPE_ID = {}
local function checkstrand(self)
  if type(self) ~= "table" or self._ROPE_ID ~= _ROPE_ID then
    error("Expected ':' when calling method on Rope.", 3)
  end
end
local function strand(char)
  return {
    _ROPE_ID = _ROPE_ID,

    -- Concatenate a rope.
    Concat = function(self)
      checkstrand(self)

      return self.char .. self.next:Concat()
    end,

    -- This function inserts a new strand in between two strands of a rope.
    -- returns what was originally after the current rope.
    InsertBetweenNext = function(self, inserted)
      checkstrand(self)

      if self.next == NULL_ROPE then error("Cannot insert between strand and NULL", 2) end

      local next = self.next
      next.previous = inserted
      self.next = inserted

      inserted.previous = self
      inserted.next = next

      return next
    end,

    -- Insert a new strand after this one, returns that strand.
    Insert = function(self, strand)
      checkstrand(self)

      if self.next ~= NULL_ROPE then error("Cannot insert between two strands", 2) end

      self.next = strand

      return strand
    end,

    -- Iterate until we meet the NULL_ROPE
    Iterate = function(self)
      local next = self
      return function()
        local current = next
        if current == NULL_ROPE then return end
        next = next.next
        return current.char
      end
    end,
    previous = NULL_ROPE,
    next = NULL_ROPE,
    char = char
  }
end

local function readData()
  local ropeBegin = strand("")
  local selected = ropeBegin

  for char in data[1]:gmatch(".") do
    selected = selected:Insert(strand(char))
  end

  local polymerPairs = {}

  for i = 3, data.n do
    local a, b, c = data[i]:match("(.)(.) %-> (.)")
    polymerPairs[a .. b] = c
  end

  return ropeBegin, polymerPairs
end

local function doPairs(ropeBegin, polymerPairs)
  local current = ropeBegin
  while current.next ~= NULL_ROPE do
    local nextChar = current.next.char

    if polymerPairs[current.char .. nextChar] then
      current = current:InsertBetweenNext(strand(polymerPairs[current.char .. nextChar]))
    else
      current = current.next
    end
  end
end

local function run()
  print("Reading data...")
  local ropeBegin, polymerPairs = readData()

  print("Main loop...")
  for i = 1, 10 do
    doPairs(ropeBegin, polymerPairs)
  end

  print("Counting elements...")
  local elements = {}
  for char in ropeBegin:Iterate() do
    if #char == 1 then
      if not elements[char] then
        elements[char] = 1
      else
        elements[char] = elements[char] + 1
      end
    end
  end

  print("Finding max and min...")
  local max, min = -math.huge, math.huge
  local maxC, minC = "", ""
  for char, value in pairs(elements) do
    if value > max then
      max = value
      maxC = char
    end
    if value < min then
      min = value
      minC = char
    end
  end

  print("Max:", maxC, max)
  print("Min:", minC, min)

  finalOutput(max - min)
  output(tostring(max - min))
  finalize()
end

run()
