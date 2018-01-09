do
  local _parent_0 = ActiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _parent_0.getStats(self)
      table.insert(stats, "Duration: " .. self.effect_time .. "s")
      return stats
    end,
    update2 = function(self, dt)
      _parent_0.update2(self, dt)
      if self.used then
        return self.effect_sprite:update(dt)
      end
    end,
    draw2 = function(self)
      _parent_0.draw2(self)
      if self.used then
        love.graphics.push("all")
        love.graphics.setShader(Driver.shader)
        for k, t in pairs(self.player.turret) do
          if t.buffed then
            self.effect_sprite:draw(t.position.x, t.position.y)
          end
        end
        love.graphics.setShader()
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        30,
        27,
        24,
        21,
        18
      })[self.rarity]
      local sprite = Sprite("item/moltenCoreActive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        for k, t in pairs(player.turret) do
          t.buffed = true
          t.damage = t.damage * 2
          t.health = t.health * 2
          t.max_health = t.max_health * 2
        end
      end
      _parent_0.__init(self, sprite, cd, effect)
      self.name = "Frosty the Turret"
      self.description = "Boosts turret damage and health"
      self.effect_time = ({
        10,
        11,
        12,
        13,
        14
      })[self.rarity]
      self.effect_sprite = Sprite("effect/damageBoost.tga", 32, 32, 0.5, 1)
      self.onEnd = function()
        for k, t in pairs(self.player.turret) do
          if t.buffed then
            t.buffed = nil
            t.damage = t.damage / 2
            t.health = t.health / 2
            t.max_health = t.max_health / 2
          end
        end
      end
    end,
    __base = _base_0,
    __name = "MoltenCoreActive",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
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
  MoltenCoreActive = _class_0
end
