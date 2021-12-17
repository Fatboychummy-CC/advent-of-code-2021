-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

-- read all values into 2d table.
local nodes = {w = #data[1], h = data.n}
local function readData()
  for y = 1, nodes.h do
    nodes[y] = {}
    for x = 1, nodes.w do
      nodes[y][x] = {flashed = false, energy = tonumber(data[y]:sub(x, x)), neighbours = {n = 0}}
      if type(nodes[y][x].energy) ~= "number" then
        error(string.format("Position (%d,%d): tonumber failed.", x, y), 0)
      end
    end
  end
end

local directions = {
  { 0,  1},
  { 1,  0},
  { 1,  1},
  { 0, -1},
  {-1,  0},
  {-1, -1},
  { 1, -1},
  {-1,  1}
}
-- determine neighbour positions for a specific position.
local function getNeighbours(x, y)
  local neighbours = {}

  for i = 1, 8 do
    neighbours[i] = {x + directions[i][1], y + directions[i][2]}
  end

  return neighbours
end
-- populate neighbours of each node.
local function populateNodes()
  for y = 1, nodes.h do
    for x = 1, nodes.w do
      local node = nodes[y][x]
      local neighbourinos = getNeighbours(x, y)
      for i = 1, 8 do
        local _x, _y = neighbourinos[i][1], neighbourinos[i][2]
        if _x > 0 and _y > 0 and _x <= nodes.w and _y <= nodes.h then
          node.neighbours.n = node.neighbours.n + 1
          node.neighbours[node.neighbours.n] = nodes[_y][_x]
        end
      end
    end
  end
end

local function resetFlash()
  for y = 1, nodes.h do
    local Y = nodes[y]
    for x = 1, nodes.w do
      Y[x].flashed = false
    end
  end
end

-- determine which nodes are going to flash this tick
local function getInitialFlashers()
  local flashers = {n = 0}

  for y = 1, nodes.h do
    local Y = nodes[y]
    for x = 1, nodes.w do
      local node = Y[x]
      if node.energy > 9 then
        flashers.n = flashers.n + 1
        flashers[flashers.n] = node
      end
    end
  end

  return flashers
end

-- flash a single node.
-- TODO: Fix this function.
local function flashNode(node)
  if node.flashed then return {n = 0} end
  local extras = {node, n = 1}

  node.flashed = true

  for i = 1, node.neighbours.n do
    local neighbour = node.neighbours[i]

    neighbour.energy = neighbour.energy + 1

    if not neighbour.flashed and neighbour.energy > 9 then
      local _extras = flashNode(neighbour)

      for i = 1, _extras.n do
        extras.n = extras.n + 1
        extras[extras.n] = _extras[i]
      end
    end
  end

  node.energy = 0

  return extras
end

-- flash a given list of flashers, returns a list of all nodes which flashed.
local function flashFlashers(flashers)
  local flashed = {n = 0}

  local flashMap = {}

  for i = 1, flashers.n do
    local node = flashers[i]
    local flashes = flashNode(node)
    for i = 1, flashes.n do
      flashMap[flashes[i]] = true
    end
  end

  for k in pairs(flashMap) do
    flashed.n = flashed.n + 1
    flashed[flashed.n] = k
  end

  return flashed
end

local function markFlashed(flashed)
  for i = 1, flashed.n do
    flashed[i].energy = 0
  end
end

-- increment energy level of all nodes.
local function incrementAll()
  for y = 1, nodes.h do
    local Y = nodes[y]
    for x = 1, nodes.w do
      Y[x].energy = Y[x].energy + 1
    end
  end
end

print("Reading data...")
readData()

print("Populating nodes...")
populateNodes()

print("Main loop.")

local total = nodes.w * nodes.h
local i = 0
repeat
  i = i + 1
  resetFlash()
  incrementAll()
  local flashers = getInitialFlashers()
  local flashed = flashFlashers(flashers)
  markFlashed(flashed)
until flashed.n == total or i > 999 -- a value of 1000 will mean failure.

finalOutput(i)

finalize()
