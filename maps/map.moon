export class MapCreator
  new: =>
    @maps = {}

    for i = 1, 1
      @maps[i] = love.image.newImageData ("assets/sprites/maps/" .. i .. ".tga")

  loadMap: (num) =>
    current = @maps[num]

    width = current\getWidth!
    height = current\getHeight!

    width_scale = Screen_Size.border[3] / width
    height_scale = Screen_Size.border[4] / height

    mapped_y = Screen_Size.border[2]
    for y = 0, height - 1
      mapped_x = 0
      for x = 0, width - 1
        color = Color current\getPixel x, y
        if not color\equals Color!
          wall = Wall mapped_x, mapped_y, width_scale, height_scale, color
          Driver\addObject wall, EntityTypes.wall
        mapped_x += width_scale
      mapped_y += height_scale

    --print "Loaded " .. #Driver.objects[EntityTypes.wall] .. " walls"
