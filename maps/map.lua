do
  local _class_0
  local _base_0 = {
    loadMap = function(self, num)
      local current = self.maps[num]
      local width = current:getWidth()
      local height = current:getHeight()
      local width_scale = Screen_Size.border[3] / width
      local height_scale = Screen_Size.border[4] / height
      for y = 0, height - 1 do
        for x = 0, width - 1 do
          local color = Color(current:getPixel(x, y))
          if not color:equals(Color()) then
            local mapped_x = math.floor((map(x, 0, width - 1, 0, Screen_Size.border[3])))
            local mapped_y = math.floor((map(y, 0, height - 1, 0, Screen_Size.border[4])))
            local wall = Wall(mapped_x, mapped_y, width_scale, height_scale, color)
            Driver:addObject(wall, EntityTypes.wall)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
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
