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
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        20,
        18,
        16,
        14,
        12
      })[self.rarity]
      local sprite = Sprite("item/emp.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local filters = {
          EntityTypes.enemy,
          EntityTypes.boss
        }
        for k2, filter in pairs(filters) do
          if Driver.objects[filter] then
            for k, v in pairs(Driver.objects[filter]) do
              v.movement_disabled = true
            end
          end
        end
      end
      _class_0.__parent.__init(self, sprite, cd, effect)
      self.name = "EMP"
      self.description = "Disables enemies"
      self.effect_time = ({
        6,
        7,
        8,
        9,
        10
      })[self.rarity]
      self.onEnd = function()
        local filters = {
          EntityTypes.enemy,
          EntityTypes.boss
        }
        for k2, filter in pairs(filters) do
          if Driver.objects[filter] then
            for k, v in pairs(Driver.objects[filter]) do
              v.movement_disabled = false
            end
          end
        end
      end
    end,
    __base = _base_0,
    __name = "EMPActive",
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
  EMPActive = _class_0
end
