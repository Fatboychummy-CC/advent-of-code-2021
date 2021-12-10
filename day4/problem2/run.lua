-- Ensure memory is cleared.
new()

-- load the input data from file.
local data = input()

-- This is purely for debugging purposes to ensure I do stuff correctly.
local _MARKER = {}
local function checkself(self)
  if type(self) ~= "table" or self._MARKER ~= _MARKER then
    error("Expected ':' when making method call.", 3)
  end
end

--[[
    We'll create "Board" objects which have some helpful methods to check if wins occur when they change.
    The board is instantiated from the given line as `inputStart`

]]
local function newBoard(inputStart)
  -- Load all of the data from the game board.
  local boardData = {}

  -- This lookup table will be a hashmap of all numbers in the matrix, reducing search time for the positions.
  local lookup = {}

  for i = 0, 4 do
    local line = {}
    local n = 0

    -- There is no verification to be done -- unlike in real bingo, numbers can be in any slot I guess.
    -- However, it is assumed no number will be given twice
    for id in data[inputStart + i]:gmatch("%d+") do
      -- increment n
      n = n + 1

      -- store whether this position is marked and the number.
      line[n] = {false, tonumber(id)}

      -- add to the lookup table.
      lookup[tonumber(id)] = {n, i + 1}
    end

    -- Add the line of data
    boardData[i + 1] = line
  end

  return {
    _MARKER = _MARKER, -- again, debugging purposes
    board = boardData,
    lookup = lookup,

    -- Sum method will check through this entire board and sum all of the items that are false.
    Sum = function(self)
      checkself(self)

      local sum = 0

      -- for each position
      for y = 1, 5 do
        for x = 1, 5 do
          -- check if it's been marked, and if not add to sum.
          if not self.board[y][x][1] then
            sum = sum + self.board[y][x][2]
          end
        end
      end

      return sum
    end,

    -- Check method will check if this board has won, given a change at x,y position.
    Check = function(self, x, y)
      checkself(self)

      -- check horizontal
      local horiWon = true
      for i = 1, 5 do
        if not self.board[y][i][1] then
          horiWon = false
          break
        end
      end

      -- If we won, compute sum.
      if horiWon then
        return true, self:Sum()
      end

      -- check vertical
      local vertiWon = true
      for i = 1, 5 do
        if not self.board[i][x][1] then
          vertiWon = false
          break
        end
      end

      -- If we won, compute sum.
      if vertiWon then
        return true, self:Sum()
      end

      return false
    end,

    -- Mark method will mark
    Mark = function(self, n)
      checkself(self)

      -- if this number is in our board.
      if self.lookup[n] then
        -- mark it
        local x, y = table.unpack(self.lookup[n], 1, 2)
        if not self.board[y] or not self.board[y][x] then
          print(textutils.serialize(self.lookup[n]))
          error(string.format("board missing datapoints %s %s from lookup.", y, x), 2)
        end
        self.board[y][x][1] = true

        -- then check if that made us win.
        return self:Check(x, y)
      end

      -- can't win if nothing changed...
      return false
    end,

    -- Clear method will set the entire board to false.
    Clear = function(self)
      checkself(self)

      for y = 1, 5 do
        for x = 1, 5 do
          self.board[y][x] = false
        end
      end
    end
  }
end

--[[
    We will read the input data into game boards, and an order of numbers.
]]
local function getGameData()
  -- read the order of numbers into memory.
  local nums = {n = 0}
  for num in data[1]:gmatch("%d+") do
    nums.n = nums.n + 1
    nums[nums.n] = tonumber(num)
  end

  -- read all the gameboards into memory.
  local boards = {n = 0}
  for i = 3, data.n, 6 do
    boards.n = boards.n + 1
    boards[boards.n] = newBoard(i)
  end

  return {nums = nums, boards = boards}
end

--[[
    We will run the game, until one board wins.
    We will return the sum of winning line and last number.
]]
local function runGame()
  local game = getGameData()

  -- for each number in the input.
  for i = 1, game.nums.n do
    local nextNumber = game.nums[i]

    -- for each board in the game.
    -- We iterate backwards this time so when we remove boards that have won from the list, we do not cause any issues.
    for i = game.boards.n, 1, -1 do
      -- mark the number on the board
      local boardHasWon, lineSum = game.boards[i]:Mark(nextNumber)

      -- and check if it won
      if boardHasWon then
        if game.boards.n == 1 then
          -- if we only have one board left, return that it's the last one.
          return lineSum, nextNumber
        else
          -- otherwise, remove it from the list of game boards
          -- note: We use table.remove here instead of just nil-ing it, so that the table shifts back to fill the gap.
          table.remove(game.boards, i)

          -- also decrement the .n value lol
          game.boards.n = game.boards.n - 1
        end
      end
    end
  end

  error("End of input reached but no board has won!", 0)
end

local sum, num = runGame()

print(string.format("We have detected which board wins last, but it's ID is unimportant apparently. It has an unmarked sum of %d. The last number called was %d.", sum, num))
print(string.format("The winning score is: %d", sum * num))
finalOutput(sum * num)

-- mark this data to be written to file (for easy copy/paste)
output(tostring(sum * num))

-- write the output file.
finalize()
