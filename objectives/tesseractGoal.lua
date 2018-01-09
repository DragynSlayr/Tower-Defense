do
  local _parent_0 = GameObject
  local _base_0 = {
    onCollide = function(self, entity)
      local start_damage = entity.damage
      entity.damage = entity.damage * self.reduction
      _parent_0.onCollide(self, entity)
      entity.damage = start_damage
    end,
    update = function(self, dt)
      _parent_0.update(self, dt)
      local health = 0
      local max_health = 0
      if Driver.objects[EntityTypes.goal] then
        for k, g in pairs(Driver.objects[EntityTypes.goal]) do
          if g.capture_amount then
            health = health + g.capture_amount
            max_health = max_health + g.max_health
          end
        end
      end
      self.reduction = health / max_health
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("objective/tesseract.tga", 32, 32, 1, 56 / 32)
      _parent_0.__init(self, x, y, sprite)
      self.id = EntityTypes.goal
      self.goal_type = GoalTypes.tesseract
      self.health = 100
      self.max_health = self.health
      self.reduction = 0
      self.solid = false
      self.item_drop_chance = 0.1
      self.score_value = 75
      self.exp_given = self.score_value + (self.score_value * 0.25 * Objectives:getLevel())
    end,
    __base = _base_0,
    __name = "TesseractGoal",
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
  TesseractGoal = _class_0
end
