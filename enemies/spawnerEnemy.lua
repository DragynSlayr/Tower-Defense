do
  local _class_0
  local _parent_0 = Enemy
  local _base_0 = {
    __tostring = function(self)
      return "T: " .. self.enemyType .. "\tH: " .. self.max_health .. "\tD: " .. self.damage .. "\tS: " .. self.max_speed
    end,
    kill = function(self)
      _class_0.__parent.__base.kill(self)
      local enemy = PlayerEnemy(self.position.x - 10, self.position.y)
      enemy.solid = false
      enemy.value = 0.25
      Driver:addObject(enemy, EntityTypes.enemy)
      enemy = PlayerEnemy(self.position.x + 10, self.position.y)
      enemy.solid = false
      enemy.value = 0.25
      Driver:addObject(enemy, EntityTypes.enemy)
      enemy = PlayerEnemy(self.position.x, self.position.y - 10)
      enemy.solid = false
      enemy.value = 0.25
      Driver:addObject(enemy, EntityTypes.enemy)
      enemy = PlayerEnemy(self.position.x, self.position.y + 10)
      enemy.solid = false
      enemy.value = 0.25
      return Driver:addObject(enemy, EntityTypes.enemy)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("enemy/dart.tga", 17, 17, 1, 2)
      local attack_speed = math.max(0.4, 0.65 - (0.01 * Objectives:getScaling()))
      _class_0.__parent.__init(self, x, y, sprite, 1, attack_speed)
      self.enemyType = EnemyTypes.spawner
      self.score_value = 50
      self.exp_given = self.score_value + (self.score_value * 0.15 * Objectives:getLevel())
      self.health = math.min(400, 12 + (66 * Objectives:getScaling()))
      self.max_health = self.health
      self.max_speed = math.min(450 * Scale.diag, (150 + (50 * Objectives:getScaling())) * Scale.diag)
      self.speed_multiplier = self.max_speed
      self.damage = math.min(28, 1 + (4.45 * Objectives:getScaling()))
      local sound = Sound("spawner_enemy_death.ogg", 0.75, false, 1.25, true)
      self.death_sound = MusicPlayer:add(sound)
    end,
    __base = _base_0,
    __name = "SpawnerEnemy",
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
  SpawnerEnemy = _class_0
end
