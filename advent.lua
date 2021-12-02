local day, problem = ...
day, problem = tonumber(day), tonumber(problem)

if not day or not problem then
  error("Bruh you are idiot like BIG idiot!", 0)
end

local data = {n = 0}

function _G.new()
  data = {n = 0}
end

function _G.input()
  local _data = {n = 0}

  for line in io.lines(string.format("day%d/input.txt", day)) do
    _data.n = _data.n + 1
    _data[_data.n] = line
  end

  return _data
end

function _G.output(line)
  data.n = data.n + 1
  data[data.n] = line
end

function _G.finalize()
  local h = io.open("output.txt", 'w')
  for i = 1, data.n do
    h:write(data[i])
  end
  h:close()
end

shell.run(string.format("day%d/problem%d/run.lua", day, problem))
