do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _class_0.__parent.__base.getStats(self)
      table.insert(stats, "Duration: " .. self.effect_time .. "s")
      return stats
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      self.rarity = self:getRandomRarity()
      local cd = ({
        20,
        19,
        18,
        17,
        16
      })[self.rarity]
      local sprite = Sprite("item/wholeHogActive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        self.player.knocking_back = true
      end
      _class_0.__parent.__init(self, x, y, sprite, cd, effect)
      self.name = "Whole Hog"
      self.description = "Player bullets do knockback"
      self.effect_time = ({
        10,
        11,
        12,
        13,
        14
      })[self.rarity]
      self.effect_timer = 0
      self.onEnd = function()
        self.player.knocking_back = false
      end
    end,
    __base = _base_0,
    __name = "WholeHogActive",
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
  WholeHogActive = _class_0
end
