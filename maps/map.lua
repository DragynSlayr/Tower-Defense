do
  local _base_0 = {
    loadMap = function(self, num)
      local current = self.maps[num]
      local width = current:getWidth()
      local height = current:getHeight()
      local width_scale = Screen_Size.border[3] / width
      local height_scale = Screen_Size.border[4] / height
      local mapped_y = Screen_Size.border[2]
      for y = 0, height - 1 do
        local mapped_x = 0
        for x = 0, width - 1 do
          local color = Color(current:getPixel(x, y))
          if not color:equals(Color()) then
            local wall = Wall(mapped_x, mapped_y, width_scale, height_scale, color)
            Driver:addObject(wall, EntityTypes.wall)
          end
          mapped_x = mapped_x + width_scale
        end
        mapped_y = mapped_y + height_scale
      end
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self)
      self.maps = { }
      for i = 1, 1 do
        self.maps[i] = (love.graphics.newImage("assets/sprites/maps/" .. i .. ".tga")):getData()
      end
    end,
    __base = _base_0,
    __name = "MapCreator"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MapCreator = _class_0
end
