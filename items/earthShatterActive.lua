do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = {
    createShatter = function(self, x, y, angle)
      local shatter = FrostField(x, y)
      shatter.sprite = Sprite("background/earthShatter.tga", 32, 32, 1, 6)
      shatter.sprite.color[4] = 200
      shatter.sprite.rotation = angle
      shatter.life_time = 6
      shatter.frost_delay = 0.2
      return Driver:addObject(shatter, EntityTypes.background)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/earthShatterActive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        if player.speed:getLength() == 0 then
          for i = 0, 300, 60 do
            x = 138 * Scale.width
            local v = Vector(x, 0)
            v:rotate((i / 180) * math.pi)
            v:add(player.position)
            x, y = v:getComponents()
            local angle = (i / 180) * math.pi
            self:createShatter(x, y, angle + (math.pi / 2))
          end
        else
          local angle = player.speed:getAngle()
          for i = 1, 6 do
            x = (i - 1) * (96 * Scale.width)
            local v = Vector(x, 0)
            v:rotate(angle)
            v:add(player.position)
            x, y = v:getComponents()
            self:createShatter(x, y, angle + (math.pi / 2))
          end
        end
      end
      _class_0.__parent.__init(self, x, y, sprite, 1, effect)
      self.name = "Earth Shatter"
      self.description = "Slow enemies"
    end,
    __base = _base_0,
    __name = "EarthShatterActive",
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
  EarthShatterActive = _class_0
end
