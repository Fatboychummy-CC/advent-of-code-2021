--[[
    QUICK DISCLAIMER
    There is no actual "problem 3" -- I just used this so my system would still work.


    Here's a version of this which uses term redirects and paintutils to count overlaps.
]]


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

-- redirect object for use with paintutils.
local redirect = {x=1,y=1}
function redirect.setCursorPos(x, y)
  redirect.x = x
  redirect.y = y
end
function redirect.write()
  -- if node already visited, increase our counter.
  -- however, only increase the counter if we've not increased it for this node yet.
  if points[redirect.y][redirect.x] == 1 then
    count = count + 1
  end

  -- mark node as visited
  points[redirect.y][redirect.x] = points[redirect.y][redirect.x] + 1
end


-- actually run the code.
print("Counting overlaps using paintutils...")
local old = term.redirect(redirect)
for i = 1, lines.n do
  paintutils.drawLine(table.unpack(lines[i], 1, 4))
end
term.redirect(old)

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
