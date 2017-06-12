export class MapCreator
  new: =>
    @maps = {}

    for i = 1, 1
      @maps[i] = (love.graphics.newImage "assets/sprites/maps/" .. i .. ".tga")\getData!

  loadMap: (num) =>
    current = @maps[num]

    width = current\getWidth!
    height = current\getHeight!

    width_scale = Screen_Size.border[3] / width
    height_scale = Screen_Size.border[4] / height

    for y = 0, height - 1
      for x = 0, width - 1
        color = Color current\getPixel x, y
        if not color\equals Color!
          mapped_x = math.floor (map x, 0, width - 1, 0, Screen_Size.border[3])
          mapped_y = math.floor (map y, 0, height - 1, 0, Screen_Size.border[4])
          wall = Wall mapped_x, mapped_y, width_scale, height_scale, color
          Driver\addObject wall, EntityTypes.wall
