do
  local _class_0
  local _parent_0 = Wave
  local _base_0 = {
    entityKilled = function(self, entity)
      if entity == self.boss then
        self.complete = true
        if self.boss.trail then
          return Driver:removeObject(self.boss.trail, false)
        end
      end
    end,
    start = function(self)
      self.boss = Objectives:spawn((self.boss), EntityTypes.boss)
      if self.boss.trail then
        return Driver:addObject(self.boss.trail, EntityTypes.particle)
      end
    end,
    draw = function(self)
      self.parent.message1 = "\t" .. "BOSS BATTLE!!"
      return _class_0.__parent.__base.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, boss)
      _class_0.__parent.__init(self, parent)
      self.boss = boss
    end,
    __base = _base_0,
    __name = "BossWave",
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
  BossWave = _class_0
end
