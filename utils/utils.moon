-- Seed random and dispose of some values
math.randomseed os.time!
for i = 1, 3 do math.random!

-- Get a random sign
export randomSign = () ->
  if math.random 0, 1 == 1
    return 1
  else
    return -1

-- Get a random point on a circle
-- radius: The radius of the circle
export getRandomUnitStart = (radius = love.graphics.getHeight! / 3) ->
  -- Create a Point
  point = Point 0, 1

  -- Find a random rotation
  rand_num = ((math.random 0, 361) / 360) * (2 * math.pi)

  -- Rotate the point
  point\rotate rand_num

  -- Expand Point
  point.x *= radius
  point.y *= radius

  -- Return Point coordinates
  return point\getComponents!

-- Clamps a number between two values
-- x: The number to clamp
-- min: Minimum value for number
-- max: Maximum value for number
export clamp = (x, min, max) ->
  -- Return a number in the range [min, max]
  if x <= min
    return min
  elseif x >= max
    return max
  else
    return x

-- Shuffles a list in place
-- list: The list to shuffle
export shuffle = (list) ->
  copy = {}
  -- Copy the list
  for k, v in pairs list
    copy[k] = v

  -- Shuffle the list
  for k, v in pairs list
    i = math.random #copy
    list[k] = copy[i]
    table.remove copy, i

-- Get random element from list
-- list: The list to choose from
export pick = (list) ->
  num = math.random(1, #list)
  return list[num]

-- Maps a value in [low, high] to [newLow, newHigh]
-- value: The value to map
-- low: Original lowest possible value
-- high: Original highest possible value
-- newLow: New lowest value
-- newHigh: New highest value
export map = (value, low, high, newLow, newHigh) ->
  b = (high - low)
  if b == 0
    return 0
  else
    a = (value - low) * (newHigh - newLow)
    return (a / b) + newLow

export ljust = (str, length) ->
  str = tostring str
  if #str >= length
    return str
  else
    num = length - #str
    for i = 1, num
      str ..= " "
    return str

export rjust = (str, length) ->
  str = tostring str
  if #str >= length
    return str
  else
    num = length - #str
    for i = 1, num
      str = " " .. str
    return str

export reverse = (str) ->
  str = tostring str
  s2 = ""
  for i = #str, 1, -1
    s2 ..= string.sub str, i, i
  return s2

export lstrip = (str) ->
  str = tostring str
  found = false
  s2 = ""
  for i = 1, #str
    char = string.sub str, i, i
    if not found
      if not (char == ' ' or char == '\n' or char == '\t' or char == '\r')
        found = true
        s2 ..= char
    else
      s2 ..= char
  return s2

export rstrip = (str) ->
  return reverse lstrip reverse str

export strip = (str) ->
  return lstrip rstrip str

export split = (str, char) ->
  str = tostring str
  splitted = {}
  s = ""
  for i = 1, #str
    c = string.sub str, i, i
    if c == char
      splitted[#splitted + 1] = s
      s = ""
    else
      s ..= c
  splitted[#splitted + 1] = s
  return splitted

export trim = (str, len) ->
  str = tostring str
  if #str <= len
    return str
  else
    s = ""
    for i = 1, len
      s ..= string.sub str, i, i
    return s

export tableToString = (tab, depth = 0) ->
  if (type tab) == "table"
    s = "{ "
    for k, v in pairs tab
      if (type v) == "table"
        s ..= "\n"
        for i = 1, depth + 1
          s ..= "\t"
        s ..= (tableToString v, depth + 1) .. "\n"
        for i = 1, depth
          s ..= "\t"
      else
        s ..= "\'" .. (tableToString v) .. "\' "
    s ..= "}"
    return s
  else
    return tostring tab
