do
  local _class_0
  local _parent_0 = HomingProjectile
  local _base_0 = {
    update = function(self, dt)
      if not self.alive then
        return 
      end
      if not self.target then
        self.health = 0
      end
      if not self:isOnScreen(Screen_Size.bounds) then
        self.health = 0
      end
      _class_0.__parent.__base.update(self, dt)
      local filters = {
        EntityTypes.player,
        EntityTypes.turret
      }
      for k2, filter in pairs(filters) do
        if Driver.objects[filter] then
          for k, v in pairs(Driver.objects[filter]) do
            local target = v:getHitBox()
            if v.getAttackHitBox then
              target = v:getAttackHitBox()
            end
            local bullet = self:getHitBox()
            bullet.radius = bullet.radius + self.attack_range
            if target:contains(bullet) then
              v:onCollide(self)
              MusicPlayer:play(self.death_sound)
              self:kill()
            end
          end
        end
      end
    end,
    draw = function(self)
      _class_0.__parent.__base.draw(self)
      if DEBUGGING then
        love.graphics.push("all")
        love.graphics.setShader()
        love.graphics.setColor(0, 127, 127, 200)
        love.graphics.circle("fill", self.target.position.x, self.target.position.y, 20, 360)
        return love.graphics.pop()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, speed, dist, sprite)
      if dist == nil then
        dist = Screen_Size.width
      end
      local target_pos = Vector(speed:getComponents())
      target_pos = target_pos:multiply(dist)
      target_pos:add((Vector(x, y)))
      _class_0.__parent.__init(self, x, y, (GameObject(target_pos.x, target_pos.y, sprite)), sprite)
      self.speed_multiplier = 100
      self.damage = 1 / 10
    end,
    __base = _base_0,
    __name = "LinearProjectile",
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
  LinearProjectile = _class_0
end
