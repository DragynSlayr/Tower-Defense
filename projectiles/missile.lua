do
  local _class_0
  local _parent_0 = HomingProjectile
  local _base_0 = {
    findTarget = function(self)
      local targets = { }
      if Driver.objects[EntityTypes.enemy] then
        targets = concatTables(targets, Driver.objects[EntityTypes.enemy])
      end
      if Driver.objects[EntityTypes.boss] then
        targets = concatTables(targets, Driver.objects[EntityTypes.boss])
      end
      if Driver.objects[EntityTypes.goal] then
        local goals = {
          GoalTypes.attack,
          GoalTypes.capture
        }
        for k, g in pairs(Driver.objects[EntityTypes.goal]) do
          if tableContains(goals, g.goal_type) then
            table.insert(targets, g)
          end
        end
      end
      return pick(targets)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("projectile/missile.tga", 32, 16, 1, 1)
      sprite:scaleUniformly(1.25, 1.50)
      _class_0.__parent.__init(self, x, y, nil, sprite)
      self.damage = Stats.player[3] * 120
      self.speed_multiplier = 250
      self.target = self:findTarget()
      if not self.target then
        self:kill()
      end
      local sound = Sound("player_missile.ogg", 0.25, false, 0.50, true)
      self.death_sound = MusicPlayer:add(sound)
    end,
    __base = _base_0,
    __name = "Missile",
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
  Missile = _class_0
end
