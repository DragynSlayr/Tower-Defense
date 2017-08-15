do
  local _class_0
  local _base_0 = {
    entityKilled = function(self, entity)
      return self.wave:entityKilled(entity)
    end,
    nextWave = function(self)
      self.parent.difficulty = self.parent.difficulty + 1
    end,
    start = function(self)
      self.complete = false
      self.wave_count = 1
      self:nextWave()
      self.started = true
    end,
    finish = function(self)
      Driver:clearObjects(EntityTypes.turret)
      Driver:clearObjects(EntityTypes.bullet)
      Driver:clearObjects(EntityTypes.background)
      Driver:clearObjects(EntityTypes.goal)
      local hit = false
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          p.num_turrets = 0
          p.can_place = true
          p.health = p.max_health
          p.attack_range = Stats.player[2]
          if p.hit then
            hit = true
          end
        end
      end
      if not hit then
        Upgrade:add_point(3)
      else
        Upgrade:add_point(2)
      end
      self.parent.shader = nil
    end,
    update = function(self, dt)
      if not self.complete then
        if not self.started then
          self:start()
        end
        if not self.wave.complete then
          self.wave:update(dt)
          local level = self.parent:getLevel() + 1
          self.message2 = "Level " .. level .. "\tWave " .. self.wave_count .. "/3"
          if self.wave.complete then
            return self.wave:finish()
          end
        else
          self.wave_count = self.wave_count + 1
          if (self.wave_count - 1) % 3 == 0 then
            self.level_count = self.level_count + 1
            self.complete = true
            self.started = false
          else
            return self:nextWave()
          end
        end
      end
    end,
    draw = function(self)
      self.wave:draw()
      love.graphics.push("all")
      love.graphics.setColor(0, 0, 0, 255)
      Renderer:drawAlignedMessage(self.message1, 20 * Scale.height, "left", Renderer.hud_font)
      Renderer:drawAlignedMessage(self.message2, 20 * Scale.height, "center", Renderer.hud_font)
      Renderer:drawAlignedMessage(self.objective_text, 50 * Scale.height, "center", Renderer.hud_font)
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.level_count = 1
      self.wave_count = 1
      self.complete = false
      self.wave = nil
      self.message1 = ""
      self.message2 = ""
      self.objective_text = ""
      self.started = false
      self.mode_type = ""
    end,
    __base = _base_0,
    __name = "Mode"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Mode = _class_0
end
