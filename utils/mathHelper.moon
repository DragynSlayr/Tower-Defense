export class MathHelper
  new: =>
    math.randomseed os.time!
    for i = 1, 3 do math.random!

  randomSign: =>
    if math.random 0, 1 == 1
      return 1
    else
      return -1

  getRandomUnitStart: (radius = love.graphics.getHeight! / 3) =>
    vec = Vector 0, 1
    rand_num = ((math.random 0, 361) / 360) * (2 * math.pi)
    vec\rotate rand_num
    vec = vec\multiply radius
    vec\add Vector love.graphics.getWidth! / 2, love.graphics.getHeight! / 2
    return vec\getComponents!

  clamp: (x, min, max) =>
    if x <= min
      return min
    elseif x >= max
      return max
    else
      return x
