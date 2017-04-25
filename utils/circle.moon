export class Circle
  new: (x = 0, y = 0, radius = 1) =>
    @center = Point x, y
    @radius = radius

  contains: (point) =>
--    if type point == "circle"
--      @radius += point.radius

    x = point.x - @center.x
    y = point.y - @center.y

    distance = (x * x) + (y * y)
    colliding = distance <= (@radius * @radius)
    collision_distance = distance - (@radius * @radius)

--    if type point == "circle"
--      @radius -= point.radius

    return colliding, collision_distance

  getCollisionDistance: (point) =>
    colliding, collision_distance = @contains point
    if colliding
      return -collision_distance
    else
      return 0

  getCenter: =>
    return @center

  setCenter: (point) =>
    @center = point

  getRadius: =>
    return @radius

  setRadius: (radius) =>
    @radius = radius
