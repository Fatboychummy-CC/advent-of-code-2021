-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

local function node(x, y)
  return {
    x = tonumber(x),
    y = tonumber(y)
  }
end

local function fold(axis, pos)
  return {
    axis = axis,
    pos = tonumber(pos)
  }
end

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

-- read data into nodes and folds.
local function readData()
  local nodes = QIT()
  local folds = QIT()
  local nodesToggle = true

  for _, line in ipairs(data) do
    if nodesToggle then
      -- we're looking at nodes
      if line == "" then
        nodesToggle = false -- switch to folds
      else
        nodes:Insert(node(line:match("(%d+),(%d+)")))
      end
    else
      -- we're looking at folds
      folds:Insert(fold(line:match("fold along (.)=(%d+)")))
    end
  end

  return nodes, folds
end

local function checkData(nodes, folds)
  for i = 1, nodes.n do
    if not nodes[i].x then
      printError("Node", i, "missing parameter x")
      error()
    end
    if not nodes[i].y then
      printError("Node", i, "missing parameter y")
      error()
    end
  end

  for i = 1, folds.n do
    if not folds[i].axis then
      printError("Fold", i, "missing parameter axis")
      error()
    end
    if not folds[i].pos then
      printError("Fold", i, "missing parameter pos")
      error()
    end
  end

  print("Data verified.")
end

-- t   -> table of dots to fold
-- xy  -> toggle. Fold along the (false=x, true=y) axis.
-- pos -> x/y position to fold. Dots on the greater half will be reflected along this line.
local function fold(t, xy, pos)
  local out = QIT()

  local positions = {}

  for i = 1, t.n do
    local _node = t[i]
    if xy then
      -- along y axis
      if _node.y > pos then
        local newY = _node.y - ((_node.y - pos) * 2)
        if newY > pos then error("Something is seriously wrong.", 0) end
        if newY >= 0 then
          positions[string.format("%d,%d", _node.x, newY)] = true
        end
      else
        positions[string.format("%d,%d", _node.x, _node.y)] = true
      end
    else
      -- along x axis
      if _node.x > pos then
        local newX = _node.x - ((_node.x - pos) * 2)
        if newX > pos then error("Something is seriously wrong.", 0) end
        if newX >= 0 then
          positions[string.format("%d,%d", newX, _node.y)] = true
        end
      else
        positions[string.format("%d,%d", _node.x, _node.y)] = true
      end
    end
  end

  for k in pairs(positions) do
    out:Insert(node(k:match("(%d+),(%d+)")))
  end

  return out
end

local function visualize(dots)
  term.clear()
  for i = 1, dots.n do
    term.setCursorPos(dots[i].x + 1, dots[i].y + 1)
    term.write("#")
  end
end

print("Reading data...")
local nodes, folds = readData()
checkData(nodes, folds)
visualize(nodes)

for i = 1, folds.n do
  os.sleep(5)
  nodes = fold(nodes, folds[i].axis == 'y', folds[i].pos)
  visualize(nodes)
end


finalOutput(nodes.n)
output(tostring(nodes.n))
finalize()
