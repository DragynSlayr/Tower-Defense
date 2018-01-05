cheat = function()
  Inventory.boxes = 999
  Upgrade.skill_points = 255
  UI:set_screen(Screen_State.inventory)
  Driver.game_state = Game_State.inventory
end
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
  local vec = Vector(1, 0)
  local num = ((math.random(0, 361)) / 360) * 2 * math.pi
  vec:rotate(num)
  return vec:multiply(radius)
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
removeChars = function(str, chars)
  if chars == nil then
    chars = { }
  end
  str = tostring(str)
  local s = ""
  for i = 1, #str do
    local c = string.sub(str, i, i)
    local found = false
    for k, v in pairs(chars) do
      if v == c then
        found = true
        break
      end
    end
    if not found then
      s = s .. c
    end
  end
  return s
end
toTitle = function(s, sep)
  if sep == nil then
    sep = " "
  end
  local title = ""
  for k, v in pairs((split(s, sep))) do
    v = (string.upper((string.sub(v, 1, 1)))) .. (string.sub((string.lower(v)), 2))
    title = title .. (v .. " ")
  end
  return (strip(title))
end
startsWith = function(s, x)
  return ((string.sub(s, 1, #x)) == x)
end
tableToString = function(t, d)
  if d == nil then
    d = 0
  end
  if (type(t)) ~= "table" then
    error("This function only works on Tables")
  end
  local s = ""
  for i = 1, d do
    s = s .. "\t"
  end
  s = "{"
  local count = 0
  for k, v in pairs(t) do
    count = count + 1
  end
  if count > 0 then
    s = s .. "\n"
    for i = 0, d do
      s = s .. "\t"
    end
    local idx = 1
    for k, v in pairs(t) do
      if (type(v)) == "table" then
        s = s .. tableToString(t[k], d + 1)
      else
        s = s .. ("\'" .. (tostring(v)) .. "\'")
      end
      if idx ~= count then
        s = s .. ", "
      else
        s = s .. " "
      end
      idx = idx + 1
    end
  end
  s = s .. "\n"
  for i = 1, d do
    s = s .. "\t"
  end
  s = s .. "}"
  return s
end
copyTable = function(t)
  local copy = { }
  for k, v in pairs(t) do
    if (type(v)) == "table" then
      copy[k] = copyTable(t[k])
    else
      copy[k] = v
    end
  end
  return copy
end
lengthof = function(l)
  local num = 0
  for k, v in pairs(l) do
    if v then
      num = num + 1
    end
  end
  return num
end
concatTables = function(t1, t2)
  local t3 = { }
  for k, v in pairs(t1) do
    table.insert(t3, v)
  end
  for k, v in pairs(t2) do
    table.insert(t3, v)
  end
  return t3
end
indexOf = function(t, i)
  for k, v in pairs(t) do
    if v == i then
      return k
    end
  end
  return -1
end
tableContains = function(t, i)
  return (indexOf(t, i)) >= 1
end
reverseTable = function(t)
  local reversed = { }
  for k, v in pairs(t) do
    table.insert(reversed, 1, v)
  end
  return reversed
end
getAllDirectories = function(root)
  local files = getAllFiles(root)
  local directories = { }
  for k, v in pairs(files) do
    local splitted = split(v, "/")
    local directory = splitted[1]
    for i = 2, #splitted - 1 do
      directory = directory .. ("/" .. splitted[i])
    end
    if not tableContains(directories, directory) then
      table.insert(directories, directory)
    end
  end
  return directories
end
getAllFiles = function(root, current)
  if current == nil then
    current = { }
  end
  if love.filesystem.isDirectory(root) then
    local files = love.filesystem.getDirectoryItems(root)
    for k, v in pairs(files) do
      current = getAllFiles(root .. "/" .. v, current)
    end
  else
    table.insert(current, root)
  end
  return current
end
readKey = function(key)
  local contents, size = love.filesystem.read("SETTINGS")
  local lines = split(contents, "\n")
  for k, v in pairs(lines) do
    local splitted = split(v, " ")
    local read_key, value = splitted[1], splitted[2]
    if read_key == key then
      return value
    end
  end
  return nil
end
writeKey = function(key, value)
  local contents, size = love.filesystem.read("SETTINGS")
  local lines = split(contents, "\n")
  local key_found = false
  for k, v in pairs(lines) do
    local splitted = split(v, " ")
    local read_key, read_value = splitted[1], splitted[2]
    if read_key == key then
      lines[k] = key .. " " .. value
      key_found = true
      break
    end
  end
  if not key_found then
    table.insert(lines, key .. " " .. value)
  end
  local s = ""
  for i = 1, #lines - 1 do
    s = s .. (lines[i] .. "\n")
  end
  s = s .. lines[#lines]
  return love.filesystem.write("SETTINGS", s)
end
