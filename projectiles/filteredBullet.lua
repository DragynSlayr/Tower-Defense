do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    update = function(self, dt)
      if not self.alive then
        return 
      end
      if not (self:isOnScreen(Screen_Size.border)) then
        self.health = 0
        return 
      end
      if self.trail then
        self.trail:update(dt)
      end
      self.sprite:update(dt)
      self.sprite.rotation = self.speed:getAngle() + (math.pi / 2)
      self.position:add(self.speed:multiply(dt))
      if #self.filter == 0 then
        return 
      end
      for k, filter in pairs(self.filter) do
        if Driver.objects[filter] then
          for k2, o in pairs(Driver.objects[filter]) do
            local target = o:getHitBox()
            local bullet = self:getHitBox()
            bullet.radius = bullet.radius + self.attack_range
            if target:contains(bullet) then
              o:onCollide(self)
              MusicPlayer:play(self.death_sound)
              self.health = 0
            end
          end
        end
      end
    end,
    kill = function(self)
      _class_0.__parent.__base.kill(self)
      if Upgrade.player_special[1] then
        if Driver.objects[EntityTypes.player] then
          for k, p in pairs(Driver.objects[EntityTypes.player]) do
            p.health = p.health + (Stats.player[3] * 0.01)
            p.health = math.min(p.health, p.max_health)
          end
        end
      end
    end,
    draw = function(self)
      if self.speed:getLength() > 0 then
        if self.alive then
          if DEBUGGING then
            love.graphics.push("all")
            love.graphics.setColor(255, 0, 255, 127)
            love.graphics.circle("fill", self.position.x, self.position.y, self.attack_range + self:getHitBox().radius, 360)
            love.graphics.pop()
          end
          return _class_0.__parent.__base.draw(self)
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, damage, speed, filter)
      if filter == nil then
        filter = { }
      end
      local sprite = Sprite("enemy/bullet.tga", 26, 20, 1, 0.5)
      _class_0.__parent.__init(self, x, y, sprite)
      self.filter = filter
      self.damage = damage
      self.attack_range = 15 * Scale.diag
      self.speed = speed
      self.id = EntityTypes.bullet
      self.draw_health = false
      self.solid = false
      self.trail = nil
      local sound = Sound("player_bullet.ogg", 0.025, false, 1.125, true)
      self.death_sound = MusicPlayer:add(sound)
    end,
    __base = _base_0,
    __name = "FilteredBullet",
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
  FilteredBullet = _class_0
end
