export class MathHelper
  new: =>
    math.randomseed os.time!
    for i = 1, 3 do math.random!

  randomSign: =>
    if math.random 0, 1 == 1
      return 1
    else
      return -1

  getRandomUnitStart: (radius = love.graphics.getHeight! / 2) =>
    rand_num = (math.random! * 2) - 1

    x = rand_num * radius
    y = math.sqrt (radius * radius) - (x * x)

    if math.random 0, 1 == 1
      y = -y

    return x, y
    
  clamp: (x, min, max) =>
    if x <= min
      return min
    elseif x >= max
      return max
    else
      return x
