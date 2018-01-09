do
  local _parent_0 = ActiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _parent_0.getStats(self)
      table.insert(stats, "Duration: " .. self.effect_time .. "s")
      return stats
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        25,
        24,
        23,
        22,
        21
      })[self.rarity]
      local sprite = Sprite("player/test.tga", 16, 16, 2, 3.50)
      sprite:setRotationSpeed(-math.pi / 2)
      local effect
      effect = function(self, player)
        self.clone = Player(player.position.x, player.position.y)
        self.clone.is_clone = true
        self.clone.draw_health = true
        self.clone.show_stats = false
        self.clone.attack_speed = self.effect_time + 1
        self.clone.solid = false
        self.clone.sprite:setColor({
          100,
          100,
          100,
          200
        })
        self.clone.kill = function(self) end
        return Driver:addObject(self.clone, EntityTypes.player)
      end
      _parent_0.__init(self, sprite, cd, effect)
      self.name = "Twinsies"
      self.description = "Create a clone of yourself"
      self.effect_time = ({
        7,
        8,
        9,
        10,
        11
      })[self.rarity]
      self.onEnd = function()
        Driver:removeObject(self.clone, false)
        self.clone = nil
      end
    end,
    __base = _base_0,
    __name = "CloneActive",
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
  CloneActive = _class_0
end
