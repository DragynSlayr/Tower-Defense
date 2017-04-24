do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    keypressed = function(self, key)
      self.key = key
      local _exp_0 = key
      if "w" == _exp_0 then
        self.speed.x, self.speed.y = 0, -self.max_speed
      elseif "a" == _exp_0 then
        self.speed.x, self.speed.y = -self.max_speed, 0
      elseif "s" == _exp_0 then
        self.speed.x, self.speed.y = 0, self.max_speed
      elseif "d" == _exp_0 then
        self.speed.x, self.speed.y = self.max_speed, 0
      else
        self.speed.x, self.speed.y = self.speed.x, self.speed.y
      end
    end,
    keyreleased = function(self, key)
      self.key = key
      if key == "d" or key == "a" then
        self.speed.x = 0
      elseif key == "w" or key == "s" then
        self.speed.y = 0
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite)
      _class_0.__parent.__init(self, x, y, sprite)
      self.position = Vector(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
      self.max_speed = 275
    end,
    __base = _base_0,
    __name = "Player",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Player = _class_0
end
