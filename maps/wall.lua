do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    getHitBox = function(self)
      return Rectangle(self.position.x, self.position.y, self.width, self.height)
    end,
    draw = function(self)
      love.graphics.push("all")
      if DEBUGGING then
        love.graphics.setColor(0, 255, 0, 255)
        self:getHitBox():draw()
      end
      love.graphics.setShader(Driver.shader)
      love.graphics.setColor(self.color:get())
      love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
      love.graphics.setShader()
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, width, height, color)
      local sprite = Sprite("maps/block.tga", 32, 32, 1, 1)
      _class_0.__parent.__init(self, x, y, sprite)
      self.sprite.color = color:get()
      self.sprite:setScale(width / 32, height / 32)
      self.width = width
      self.height = height
      self.color = color
      self.id = EntityTypes.wall
      self.damage = 0
    end,
    __base = _base_0,
    __name = "Wall",
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
  Wall = _class_0
end
