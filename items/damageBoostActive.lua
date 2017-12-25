do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _class_0.__parent.__base.getStats(self)
      table.insert(stats, "Duration: " .. self.effect_time .. "s")
      return stats
    end,
    update2 = function(self, dt)
      _class_0.__parent.__base.update2(self, dt)
      if self.used then
        return self.effect_sprite:update(dt)
      end
    end,
    draw2 = function(self)
      _class_0.__parent.__base.draw2(self)
      if self.used then
        love.graphics.push("all")
        love.graphics.setShader(Driver.shader)
        self.effect_sprite:draw(self.player.position.x, self.player.position.y)
        love.graphics.setShader()
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        15,
        14,
        13,
        12,
        11
      })[self.rarity]
      local sprite = Sprite("item/damageBoost.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        self.player.damage = self.player.damage * 2
      end
      _class_0.__parent.__init(self, sprite, cd, effect)
      self.name = "Damage Boost"
      self.description = "Gives a temporary boost to damage"
      self.effect_time = ({
        3,
        4,
        5,
        6,
        7
      })[self.rarity]
      self.effect_sprite = Sprite("effect/damageBoost.tga", 32, 32, 0.5, 2.25)
      self.onEnd = function()
        self.player.damage = Stats.player[3]
      end
    end,
    __base = _base_0,
    __name = "DamageBoostActive",
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
  DamageBoostActive = _class_0
end
