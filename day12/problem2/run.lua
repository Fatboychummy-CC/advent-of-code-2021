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

-- I am running this in computercraft, which has a check to prevent threads from
-- running too long. This will bypass that by yielding once per second.
local nextYield = os.epoch "utc" + 1000
local function yield()
  if os.epoch "utc" > nextYield then
    os.queueEvent "fake"
    coroutine.yield "fake"
    nextYield = os.epoch "utc" + 1000
  end
end

local NODE_ID = {}
local function checknode(self)
  if type(self) ~= "table" or self._ID ~= NODE_ID then
    error("Expected ':' when calling method on Node.", 3)
  end
end
local nodes = {n = 0}
local function newNode(name)
  nodes.n = nodes.n + 1
  nodes[name] = {
    _ID = NODE_ID,
    isSmall = name:lower() == name and true or false,
    visited = false,
    neighbours = QIT(),
    name = name,

    -- Resets the node's visited property.
    Reset = function(self)
      checknode(self)

      self.visited = false
    end,

    -- Adds a neighbour to the node.
    AddNeighbour = function(self, neighbour)
      checknode(self)

      --print(neighbour, nodes[neighbour])

      self.neighbours:Insert(nodes[neighbour])
    end,

    -- Iterator function to iterate through the neighbours
    IterateNeighbours = function(self)
      checknode(self)

      local i = 0

      return function()
        i = i + 1
        if i > self.neighbours.n then return end
        return self.neighbours[i]
      end
    end
  }
end

-- Append data to a node (also creates the node if it doesn't exist).
local function appendNode(first, second)
  -- create nodes if they don't exist
  if not nodes[first] then
    newNode(first)
  end
  if not nodes[second] then
    newNode(second)
  end

  -- add neighbours
  nodes[first]:AddNeighbour(second)
  nodes[second]:AddNeighbour(first)
end

-- read nodes into the data structure.
local function readNodes()
  for _, line in ipairs(data) do
    appendNode(line:match("(.+)%-(.+)"))
  end
end

local paths = QIT()
-- recursive method to loop through all nodes.
local neighbourTraverse
local function visitNode(node, parentChain)
  -- the basest of cases. If we hit the end node, return one path.
  if node.name == "end" then
    return 1
  end
  if node.name == "start" then
    return 0
  end

  -- the baser of cases. If we are in a small cave we already traversed this time, we can't go further.
  -- Also we can create a new parent chain here for performance  (very epic)
  local newChain = QIT()
  newChain.visitedSmall = parentChain.visitedSmall
  for i = 1, parentChain.n do
    -- insert the parent
    newChain:Insert(parentChain[i])
  end


  for i = 1, parentChain.n do
    -- check for small node already traversed
    if node.isSmall and parentChain[i] == node then
      if parentChain.visitedSmall then
        return 0
      else
        newChain.visitedSmall = true
      end
    end
  end

  newChain:Insert(node)

  return neighbourTraverse(node, newChain)
end

-- traverse neighbours of a node.
neighbourTraverse = function(node, newChain)
  -- recursive case. visit each neighbour.
  local count = 0

  -- for each neighbour, recurse.
  for neighbour in node:IterateNeighbours() do
    yield()
    count = count + visitNode(neighbour, newChain)
  end


  return count
end

-- visit all nodes.
local function visitNodes()
  local parents = QIT()
  parents.visitedSmall = false
  return neighbourTraverse(nodes.start, parents)
end

print("Reading tree...")
readNodes()

print("Traversing...")
local count = visitNodes()

finalOutput(count)
output(tostring(count))
finalize()
