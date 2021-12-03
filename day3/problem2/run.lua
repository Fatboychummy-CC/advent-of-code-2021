new()

local data = input()

-- This function will iterate through a list of values and determine if 0 or 1
-- is the most common for bit i.
local function check(list, i)
  if not list then error("wtf bro", 2) end
  local n = 0
  for j = 1, list.n do
    if list[j]:sub(i, i) == '1' then
      n = n + 1
    else
      n = n - 1
    end
  end

  if n == 0 then return 2 end

  return n > 0 and 1 or 0
end

-- This function will iterate through a list of values and create a new list
-- of which only the i'th digit is the value
local function prune(list, index, value)
  local newList = {n = 0}

  for i = 1, list.n do
    if list[i]:sub(index, index) == value then
      newList.n = newList.n + 1
      newList[newList.n] = list[i]
    end
  end

  return newList
end

-- set up the initial values for the list.
local oxyRating = check(data, 1) == 1 and prune(data, 1, '1') or prune(data, 1, '0')
local co2Rating = check(data, 1) == 1 and prune(data, 1, '0') or prune(data, 1, '1')

-- loop until we no longer need to.
for i = 2, #data[1] do
  -- check if each rating has 0's or 1's dominance (or tie)
  local gotOxy = check(oxyRating, i)
  local gotCO2 = check(co2Rating, i)

  if oxyRating.n ~= 1 then
    -- if tie or 1 dominance
    if gotOxy == 1 or gotOxy == 2 then
      -- prune the list, keeping items with 1's at position i
      oxyRating = prune(oxyRating, i, '1')
    else
      -- prune the list, keeping items with 0's at position i
      oxyRating = prune(oxyRating, i, '0')
    end
  end
  if co2Rating.n ~= 1 then
    -- if tie or 1 dominance
    if gotCO2 == 1 or gotCO2 == 2 then
      -- prune the list, keeping items with 0's at position i
      co2Rating = prune(co2Rating, i, '0')
    else
      -- prune the list, keeping items with 1's at position i
      co2Rating = prune(co2Rating, i, '1')
    end
  end

  -- Exit the loop when done.
  if oxyRating.n == 0 and co2Rating.n == 0 then break end
end

print("Done. Got", oxyRating[1], "and", co2Rating[1])
print(tonumber(oxyRating[1], 2) * tonumber(co2Rating[1], 2))
output(tostring(tonumber(oxyRating[1], 2) * tonumber(co2Rating[1], 2)))

finalize()
