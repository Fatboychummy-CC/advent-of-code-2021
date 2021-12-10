-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

-- read all values into 2d table.
local height = {w = #data[1], h = data.n}
local function readData()
  for y = 1, height.h do
    height[y] = {}
    for x = 1, height.w do
      height[y][x] = {value = tonumber(data[y]:sub(x, x)), neighbours = {n = 0}}
      if type(height[y][x].value) ~= "number" then
        error(string.format("Position (%d,%d): tonumber failed.", x, y), 0)
      end
    end
  end
end

local directions = {
  {1, 0},
  {0, 1},
  {-1, 0},
  {0, -1}
}
local function getNeighbours(x, y)
  local neighbours = {}

  for i = 1, 4 do
    neighbours[i] = {x + directions[i][1], y + directions[i][2]}
  end

  return neighbours
end
local function populateNodes()
  for y = 1, height.h do
    for x = 1, height.w do
      local node = height[y][x]
      local neighbourinos = getNeighbours(x, y)
      for i = 1, 4 do
        local _x, _y = neighbourinos[i][1], neighbourinos[i][2]
        if _x > 0 and _y > 0 and _x <= height.w and _y <= height.h then
          node.neighbours.n = node.neighbours.n + 1
          node.neighbours[node.neighbours.n] = height[_y][_x]
        end
      end
    end
  end
end

local function isMin(node, x, y)
  for _, otherNode in ipairs(node.neighbours) do
    if otherNode.value <= node.value then
      return false
    end
  end

  return true
end
local function findMinimums()
  local nodes = {n = 0}

  for y = 1, height.h do
    for x = 1, height.w do
      local node = height[y][x]
      if isMin(node, x, y) then
        nodes.n = nodes.n + 1
        nodes[nodes.n] = node
      end
    end
  end

  return nodes
end

print("Reading data...")
readData()

print("Populating nodes...")
populateNodes()

print("Determining lowest values...")
local mins = findMinimums()
print("Found", mins.n, "nodes of minimum values.")

local sum = 0
for i = 1, mins.n do
  sum = sum + mins[i].value + 1
end

print("Sum of minimums is", sum)
output(tostring(sum))

finalize()
