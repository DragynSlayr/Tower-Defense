do
  local _class_0
  local _parent_0 = BackgroundObject
  local _base_0 = {
    update = function(self, dt)
      _class_0.__parent.__base.update(self, dt)
      self.timer = self.timer + dt
      if self.timer >= self.frost_delay then
        self.timer = 0
        if Driver.objects[EntityTypes.enemy] then
          for k, e in pairs(Driver.objects[EntityTypes.enemy]) do
            local target = e:getHitBox()
            local frost = self:getHitBox()
            if target:contains(frost) then
              e.speed_multiplier = e.speed_multiplier * 0.5
            end
          end
        end
        if Driver.objects[EntityTypes.boss] then
          for k, b in pairs(Driver.objects[EntityTypes.boss]) do
            local target = b:getHitBox()
            local frost = self:getHitBox()
            if target:contains(frost) then
              b.speed_multiplier = b.speed_multiplier * 0.5
            end
          end
        end
      end
      self.life_time = self.life_time - dt
      if self.life_time <= 0 then
        self.health = 0
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("background/frostField.tga", 32, 32, 2, 8)
      sprite.color[4] = 200
      _class_0.__parent.__init(self, x, y, sprite)
      self.life_time = 7.5
      self.timer = 0
      self.frost_delay = 0.1
    end,
    __base = _base_0,
    __name = "FrostField",
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
  FrostField = _class_0
end
