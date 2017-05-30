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
  local a = high - low
  local b = newHigh - newLow
  if a == 0 or b == 0 or value == 0 then
    return 0
  else
    return (value * b) / a
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
