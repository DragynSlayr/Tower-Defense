do
  local _parent_0 = BackgroundObject
  local _base_0 = {
    update = function(self, dt)
      _parent_0.update(self, dt)
      if self.elapsed >= self.max_time then
        self.sprite = self.action_sprite
      end
    end,
    draw = function(self)
      love.graphics.push("all")
      love.graphics.setShader(Driver.shader)
      local color = map(self.action_sprite.current_frame, 1, self.action_sprite.frames, 200, 0)
      love.graphics.setColor(color, color, color, 127)
      local bounds = self:getHitBox()
      love.graphics.circle("fill", self.position.x, self.position.y, bounds.radius + self.attack_range, 360)
      love.graphics.setShader()
      love.graphics.pop()
      return _parent_0.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("background/bomb.tga", 32, 32, 1, 2)
      _parent_0.__init(self, x, y, sprite)
      self.max_time = 0
      self.attack_range = 100 * Scale.diag
      self.action_sprite = ActionSprite("background/bombAction.tga", 32, 32, 3, 2, self, function(self)
        if Driver.objects[EntityTypes.enemy] then
          for k, e in pairs(Driver.objects[EntityTypes.enemy]) do
            local target = e:getHitBox()
            local bomb = self.parent:getHitBox()
            bomb.radius = bomb.radius + self.parent.attack_range
            if target:contains(bomb) then
              e:kill()
            end
          end
        end
        if Driver.objects[EntityTypes.goal] then
          local goals = {
            GoalTypes.tesseract,
            GoalTypes.attack,
            GoalTypes.find
          }
          for k, e in pairs(Driver.objects[EntityTypes.goal]) do
            if tableContains(goals, e.goal_type) then
              local target = e:getHitBox()
              local bomb = self.parent:getHitBox()
              bomb.radius = bomb.radius + self.parent.attack_range
              if target:contains(bomb) then
                e:kill()
              end
            end
          end
        end
        if Driver.objects[EntityTypes.boss] then
          for k, b in pairs(Driver.objects[EntityTypes.boss]) do
            local target = b:getHitBox()
            local bomb = self.parent:getHitBox()
            bomb.radius = bomb.radius + self.parent.attack_range
            if target:contains(bomb) then
              b:kill()
            end
          end
        end
        return self.parent:kill()
      end)
    end,
    __base = _base_0,
    __name = "Bomb",
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
  Bomb = _class_0
end
