export class Point
  new: (x = 0, y = 0) =>
    @x = x
    @y = y

  rotate: (angle) =>
    vec = Vector @x, @y
    vec\rotate angle
    @x, @y = vec\getComponents!

  getComponents: =>
    return @x, @y

  __tostring: =>
    return "(" .. @x .. ", " .. @y ..")"
