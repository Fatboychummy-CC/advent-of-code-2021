local expect = require "cc.expect"

-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

-- Read the input data into a table.
print("Reading input...")
local lines = {n = data.n}
for i = 1, data.n do
  local x1, y1, x2, y2 = data[i]:match("(%d+),(%d+) %-> (%d+),(%d+)")

  lines[i] = {tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2)}
end

print("Done.")

print("Calculating largest x/y value.")
-- I could do this dynamically, but don't feel like debugging that if I get it wrong.
local maxX, maxY = 0, 0
for i = 1, lines.n do
  local line = lines[i]

  -- check both X values.
  if line[1] > maxX then
    maxX = line[1]
  end
  if line[3] > maxX then
    maxX = line[3]
  end

  -- check both Y values.
  if line[2] > maxY then
    maxY = line[2]
  end
  if line[4] > maxY then
    maxY = line[4]
  end
end
print("Max:", maxX, maxY)

-- mark all points as un-traversed.
local points = {}
for y = 0, maxY do
  local t = {}
  points[y] = t
  for x = 0, maxX do
    t[x] = 0
  end
end

-- count variable will increment when we visit a position that has been visited before.
local count = 0

-- function to draw lines.
local function drawLine(x1, y1, x2, y2)
  expect(1, x1, "number")
  expect(2, y1, "number")
  expect(3, x2, "number")
  expect(4, y2, "number")

  if x1 == x2 then -- Drawing vertically.
    -- sort the values from lowest to highest so for loop works nice
    local ya, yb = math.min(y1, y2), math.max(y1, y2)

    -- actually "draw" the line.
    for y = ya, yb do
      -- if node already visited, increase our counter.
      -- however, only increase the counter if we've not increased it for this node yet.
      if points[y][x1] == 1 then
        count = count + 1
      end

      -- mark node as visited
      points[y][x1] = points[y][x1] + 1
    end
  elseif y1 == y2 then -- Drawing horizontally.
    -- sort the values from lowest to highest so for loop works nice
    local xa, xb = math.min(x1, x2), math.max(x1, x2)

    -- actually "draw" the line.
    for x = xa, xb do
      -- if node already visited, increase our counter.
      -- however, only increase the counter if we've not increased it for this node yet.
      if points[y1][x] == 1 then
        count = count + 1
      end

      -- mark node as visited
      points[y1][x] = points[y1][x] + 1
    end
  else -- this is a diagonal line.
    if x2 < x1 then -- sort the points so we are always drawing left-to-right.
      local tmp = x2
      x2 = x1
      x1 = tmp

      tmp = y2
      y2 = y1
      y1 = tmp
    end

    local y = 0
    for x = x1, x2 do
      -- if node already visited, increase our counter.
      -- however, only increase the counter if we've not increased it for this node yet.
      if points[y1 + y][x] == 1 then
        count = count + 1
      end

      -- mark node as visited
      points[y1 + y][x] = points[y1 + y][x] + 1

      -- increment (or decrement) so we are climbing (or falling) horizontally.
      y = y + (y2 > y1 and 1 or -1)
    end
  end
end

-- actually run the code.
print("Counting overlaps...")
for i = 1, lines.n do
  drawLine(table.unpack(lines[i], 1, 4))
end

print("Done. Got", count, "overlaps.")
finalOutput(count)
output(tostring(count))

--[[
-- this will visualize the output. For size reasons this is commented out during the main course.
for y = 0, maxY do
  local t = points[y]
  local str = ""
  for x = 0, maxX do
    str = str .. (t[x] > 0 and tostring(t[x]) or '.')
  end
  output(str)
end
]]

finalize()
