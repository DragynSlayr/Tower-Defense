do
  local _class_0
  local _base_0 = {
    contains = function(self, obj)
      local _exp_0 = obj.__class.__name
      if "Circle" == _exp_0 then
        local vec = Vector(self.center.x - obj.center.x, self.center.y - obj.center.y)
        local angle = vec:getAngle() - (math.pi / 2)
        local width = 2 * (math.sin(angle)) * obj.radius
        local height = 2 * (math.cos(angle)) * obj.radius
        local x = obj.center.x - (width / 2)
        local y = obj.center.y - (height / 2)
        local rec = Rectangle(x, y, width, height)
        if DEBUGGING then
          Renderer:enqueue(function()
            return rec:draw()
          end)
        end
        return self:contains(rec)
      elseif "Rectangle" == _exp_0 then
        local colliding_points = { }
        local result = false
        for k, p in pairs(self.corners) do
          local is_colliding, dist = obj:contains(p)
          if is_colliding then
            colliding_points[#colliding_points + 1] = dist
            result = true
          end
        end
        for k, p in pairs(obj.corners) do
          local is_colliding, dist = self:contains(p)
          if is_colliding then
            colliding_points[#colliding_points + 1] = dist
            result = true
          end
        end
        if result then
          local max = 0
          for k, v in pairs(colliding_points) do
            if v > max then
              max = v
            end
          end
          return true, max
        else
          return false, 0
        end
      elseif "Point" == _exp_0 then
        local in_x = obj.x >= self.x and obj.x <= self.x + self.width
        local in_y = obj.y >= self.y and obj.y <= self.y + self.height
        local result = in_x and in_y
        if result then
          local dist = Vector(self.x - obj.x, self.y - obj.y)
          return true, dist:getLength()
        else
          return false, 0
        end
      end
    end,
    getCollisionDistance = function(self, circ)
      local colliding, collision_distance = self:contains(circ)
      if colliding then
        return -collision_distance
      else
        return 0
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setColor(0, 255, 0, 255)
      love.graphics.rectangle("line", self.corners[1].x, self.corners[1].y, self.width, self.height)
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height)
      self.x = x
      self.y = y
      self.width = width
      self.height = height
      self.center = Point(x + (width / 2), y + (height / 2))
      self.corners = {
        (Point(x, y)),
        (Point(x + width, y)),
        (Point(x + width, y + height)),
        (Point(x, y + height))
      }
      self.radius = math.max(self.width, self.height)
    end,
    __base = _base_0,
    __name = "Rectangle"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Rectangle = _class_0
end
