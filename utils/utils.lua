math.randomseed(os.time())
for i = 1, 3 do
  math.random()
end
randomSign = function()
  if math.random(0, 1 == 1) then
    return 1
  else
    return -1
  end
end
getRandomUnitStart = function(radius)
  if radius == nil then
    radius = love.graphics.getHeight() / 3
  end
  local point = Point(0, 1)
  local rand_num = ((math.random(0, 361)) / 360) * (2 * math.pi)
  point:rotate(rand_num)
  point.x = point.x * radius
  point.y = point.y * radius
  point.x = point.x + (love.graphics.getWidth() / 2)
  point.y = point.y + (love.graphics.getHeight() / 2)
  return point:getComponents()
end
clamp = function(x, min, max)
  if x <= min then
    return min
  elseif x >= max then
    return max
  else
    return x
  end
end
shuffle = function(list)
  local copy = { }
  for k, v in pairs(list) do
    copy[k] = v
  end
  for k, v in pairs(list) do
    local i = math.random(#copy)
    list[k] = copy[i]
    table.remove(copy, i)
  end
end
pick = function(list)
  local num = math.random(1, #list)
  return list[num]
end
map = function(value, low, high, newLow, newHigh)
  local b = (high - low)
  if b == 0 then
    return 0
  else
    local a = (value - low) * (newHigh - newLow)
    return (a / b) + newLow
  end
end
ljust = function(str, length)
  str = tostring(str)
  if #str >= length then
    return str
  else
    local num = length - #str
    for i = 1, num do
      str = str .. " "
    end
    return str
  end
end
rjust = function(str, length)
  str = tostring(str)
  if #str >= length then
    return str
  else
    local num = length - #str
    for i = 1, num do
      str = " " .. str
    end
    return str
  end
end
reverse = function(str)
  str = tostring(str)
  local s2 = ""
  for i = #str, 1, -1 do
    s2 = s2 .. string.sub(str, i, i)
  end
  return s2
end
lstrip = function(str)
  str = tostring(str)
  local found = false
  local s2 = ""
  for i = 1, #str do
    local char = string.sub(str, i, i)
    if not found then
      if not (char == ' ' or char == '\n' or char == '\t' or char == '\r') then
        found = true
        s2 = s2 .. char
      end
    else
      s2 = s2 .. char
    end
  end
  return s2
end
rstrip = function(str)
  return reverse(lstrip(reverse(str)))
end
strip = function(str)
  return lstrip(rstrip(str))
end
split = function(str, char)
  str = tostring(str)
  local splitted = { }
  local s = ""
  for i = 1, #str do
    local c = string.sub(str, i, i)
    if c == char then
      splitted[#splitted + 1] = s
      s = ""
    else
      s = s .. c
    end
  end
  splitted[#splitted + 1] = s
  return splitted
end
trim = function(str, len)
  str = tostring(str)
  if #str <= len then
    return str
  else
    local s = ""
    for i = 1, len do
      s = s .. string.sub(str, i, i)
    end
    return s
  end
end
tableToString = function(tab, depth)
  if depth == nil then
    depth = 0
  end
  if (type(tab)) == "table" then
    local s = "{ "
    for k, v in pairs(tab) do
      if (type(v)) == "table" then
        s = s .. "\n"
        for i = 1, depth + 1 do
          s = s .. "\t"
        end
        s = s .. ((tableToString(v, depth + 1)) .. "\n")
        for i = 1, depth do
          s = s .. "\t"
        end
      else
        s = s .. ("\'" .. (tableToString(v)) .. "\' ")
      end
    end
    s = s .. "}"
    return s
  else
    return tostring(tab)
  end
end
