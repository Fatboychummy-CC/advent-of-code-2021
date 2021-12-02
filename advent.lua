local day, problem = ...
day, problem = tonumber(day), tonumber(problem)

if not day or not problem then
  error("Bruh you are idiot like BIG idiot!", 0)
end

local data = {}

function _G.new()
  data = {n = 0}
end

function _G.addLine(line)
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
