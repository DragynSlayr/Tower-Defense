export class Vector
  new: (x = 0, y = 0, isUnit = false) =>
    @x = x
    @y = y

    if isUnit
      @toUnitVector!

  getLength: =>
    return math.sqrt (@x * @x) + (@y * @y)

  toUnitVector: =>
    length = @getLength!
    @x /= length
    @y /= length

  getAngleBetween: (vec) =>
    angle = math.atan2 @y - vec.y, @x - vec.x
    return angle + (math.pi / 2)

  getDistanceBetween: (vec) =>
    newVec = Vector @x - vec.x, @y - vec.y
    return newVec\getLength!

  rotate: (angle) =>
    cos_angle, sin_angle = @getCosSin angle

    x = (cos_angle * @x) - (sin_angle * @y)
    y = (sin_angle * @x) + (cos_angle * @y)

    @x = x
    @y = y

  getCosSin: (angle) =>
    cos_angle = math.cos angle
    sin_angle = math.sqrt 1 - (cos_angle * cos_angle)
    cos_angle = math.sqrt 1 - (sin_angle * sin_angle)
    return cos_angle, sin_angle

  add: (vec) =>
    @x += vec.x
    @y += vec.y

  multiply: (factor) =>
    return Vector @x * factor, @y * factor

  getComponents: =>
    return @x, @y

  __tostring: =>
    return "(" .. @x .. ", " .. @y ..")"
