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

-- recursive method to loop through all nodes.
local function visitNode(node, parentChain, depth)
  depth = depth or 0

  -- the basest of cases. If we hit the end node, return one path.
  if node.name == "end" then
    return 1
  end

  -- the baser of cases. If we are in a small cave we already traversed this time, we can't go further.
  -- Also we can create a new parent chain here for performance  (very epic)
  local newChain = QIT()
  for i = 1, parentChain.n do
    -- check for small node already traversed
    if node.isSmall and parentChain[i] == node then
      return 0
    end

    -- insert the parent
    newChain:Insert(parentChain[i])
  end

  newChain:Insert(node)

  -- recursive case. visit each neighbour.
  local count = 0

  -- for each neighbour, recurse.
  for neighbour in node:IterateNeighbours() do
    count = count + visitNode(neighbour, newChain, depth + 1)
  end

  return count
end

-- visit all nodes.
local function visitNodes()
  return visitNode(nodes.start, QIT())
end

print("Reading tree...")
readNodes()

print("Traversing...")
local count = visitNodes()

finalOutput(count)
output(tostring(count))
finalize()
