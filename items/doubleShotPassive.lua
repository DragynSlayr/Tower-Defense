do
  local _class_0
  local _parent_0 = PassiveItem
  local _base_0 = {
    getStats = function(self)
      local stats = _class_0.__parent.__base.getStats(self)
      table.insert(stats, "Damage Multiplier: " .. self.damage_multiplier)
      return stats
    end,
    pickup = function(self, player)
      _class_0.__parent.__base.pickup(self, player)
      self.delay = player.attack_speed
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      self.damage_multiplier = ({
        0.5,
        0.6,
        0.7,
        0.8,
        0.9
      })[self.rarity]
      local sprite = Sprite("item/doubleShotPassive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local filters = {
          EntityTypes.enemy,
          EntityTypes.boss
        }
        if not (tableContains(filters, EntityTypes.goal)) then
          if Driver.objects[EntityTypes.goal] then
            for k, v in pairs(Driver.objects[EntityTypes.goal]) do
              if v.goal_type == GoalTypes.attack then
                table.insert(filters, EntityTypes.goal)
                break
              end
            end
          end
        end
        local bullet_speed = Vector(0, 0)
        if love.keyboard.isDown(Controls.keys.SHOOT_LEFT) then
          bullet_speed:add((Vector(-player.bullet_speed, 0)))
        end
        if love.keyboard.isDown(Controls.keys.SHOOT_RIGHT) then
          bullet_speed:add((Vector(player.bullet_speed, 0)))
        end
        if love.keyboard.isDown(Controls.keys.SHOOT_UP) then
          bullet_speed:add((Vector(0, -player.bullet_speed)))
        end
        if love.keyboard.isDown(Controls.keys.SHOOT_DOWN) then
          bullet_speed:add((Vector(0, player.bullet_speed)))
        end
        if bullet_speed:getLength() > 0 then
          local bullet = FilteredBullet(player.position.x, player.position.y, player.damage * self.damage_multiplier, bullet_speed, filters)
          bullet.sprite = Sprite("projectile/doubleShot.tga", 26, 20, 1, 0.5)
          bullet.max_dist = self:getHitBox().radius + (2 * (player.attack_range + player.range_boost))
          if player.knocking_back then
            bullet.knockback = true
          end
          return Driver:addObject(bullet, EntityTypes.bullet)
        end
      end
      _class_0.__parent.__init(self, sprite, 0, effect)
      self.name = "Another One"
      self.description = "Shoot an extra bullet"
    end,
    __base = _base_0,
    __name = "DoubleShotPassive",
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
  DoubleShotPassive = _class_0
end
