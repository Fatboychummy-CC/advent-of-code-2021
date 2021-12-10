-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

-- read all values into 2d table.
local height = {w = #data[1], h = data.n}
local function readData()
  -- for each position x, y
  for y = 1, height.h do
    height[y] = {}
    for x = 1, height.w do
      -- create a node with value and neighbours (not populated neighbours yet)
      height[y][x] = {value = tonumber(data[y]:sub(x, x)), neighbours = {n = 0}}
    end
  end
end

-- direction the neighbours can be in.
local directions = {
  {1, 0},
  {0, 1},
  {-1, 0},
  {0, -1}
}
-- function that determines positions of neighbours given a position
local function getNeighbours(x, y)
  local neighbours = {}

  -- for each direction
  for i = 1, 4 do
    -- determine position of neighbour
    neighbours[i] = {x + directions[i][1], y + directions[i][2]}
  end

  return neighbours
end

-- function that populates neighbours for each node.
local function populateNodes()
  -- for each position x, y
  for y = 1, height.h do
    for x = 1, height.w do
      -- get node and neighbours
      local node = height[y][x]
      local neighbourinos = getNeighbours(x, y)

      -- then for each neighbour
      for i = 1, 4 do
        local _x, _y = neighbourinos[i][1], neighbourinos[i][2]

        -- check if the position is in bounds
        if _x > 0 and _y > 0 and _x <= height.w and _y <= height.h then
          -- if so, add them to the list of neighbours for the node.
          node.neighbours.n = node.neighbours.n + 1
          node.neighbours[node.neighbours.n] = height[_y][_x]
        end
      end
    end
  end
end

-- function to check if this node is a "minimum node"
local function isMin(node, x, y)
  -- for each neighbour of a node
  for _, otherNode in ipairs(node.neighbours) do
    -- if it's not the lowest value of the neighbour
    if otherNode.value <= node.value then
      -- return false
      return false
    end
  end

  return true
end

-- searching through every single node, check if they're all minimums
local function findMinimums()
  local nodes = {n = 0}

  -- for each position x, y
  for y = 1, height.h do
    for x = 1, height.w do
      -- get node
      local node = height[y][x]

      -- check if the node is a min
      if isMin(node, x, y) then
        -- if so, add it to nodes list
        nodes.n = nodes.n + 1
        nodes[nodes.n] = node
      end
    end
  end

  return nodes
end

-- This function recursively counts the "ancestors" (neighbours which are higher in value)
local function countAncestors(node, nodeMap)
  -- if called recursively, keep the nodeMap.
  nodeMap = nodeMap and nodeMap or {}

  -- mark this node as traversed.
  nodeMap[node] = true

  -- for each neighbour
  for _, otherNode in ipairs(node.neighbours) do
    -- if the neighbour is higher value (but not a value 9 node)
    if otherNode.value > node.value and otherNode.value ~= 9 then
      -- traverse it too.
      countAncestors(otherNode, nodeMap)
    end
  end

  -- count the nodes in the hashmap
  local n = 0
  for k in pairs(nodeMap) do
    n = n + 1
  end

  return n
end

-- This function goes through a list of nodes then runs countAncestors on each node given.
local function determineAncestry(mins)
  local nodeSizes = {n = 0}

  for i = 1, mins.n do
    nodeSizes.n = nodeSizes.n + 1
    nodeSizes[nodeSizes.n] = countAncestors(mins[i])
  end

  return nodeSizes
end

-- Remove the largest value from a table, and return it.
local function removeLargest(t)
  local max = 0
  local maxIndex = 0

  for i = 1, t.n do
    if t[i] > max then
      max = t[i]
      maxIndex = i
    end
  end

  table.remove(t, maxIndex)
  t.n = t.n - 1

  return max
end

print("Reading data...")
readData()

print("Populating nodes...")
populateNodes()

print("Determining lowest values...")
local mins = findMinimums()
print("Found", mins.n, "nodes of minimum values.")

print("Finding ancestors of minimum nodes.")
local ancestorSizes = determineAncestry(mins)

print("Getting largest three node sizes.")
local most = {}
for i = 1, 3 do
  most[i] = removeLargest(ancestorSizes)
end

print(string.format("Maximum 3 multiplied together is: %d * %d * %d = %d", most[1], most[2], most[3], most[1] * most[2] * most[3]))
output(tostring(most[1] * most[2] * most[3]))

finalize()
