do
  local _class_0
  local _parent_0 = PassiveItem
  local _base_0 = {
    pickup = function(self, player)
      _class_0.__parent.__base.pickup(self, player)
      self.delay = player.attack_speed
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/doubleShotPassive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local filters = {
          EntityTypes.enemy,
          EntityTypes.boss
        }
        for k2, typeof in pairs(filters) do
          if Driver.objects[typeof] then
            for k, v in pairs(Driver.objects[typeof]) do
              local enemy = v:getHitBox()
              local p = player:getHitBox()
              p.radius = p.radius + (player.attack_range + player.range_boost)
              if p:contains(enemy) then
                local bullet = PlayerBullet(player.position.x, player.position.y, v, player.damage / 2)
                bullet.sprite = Sprite("projectile/doubleShot.tga", 26, 20, 1, 0.5)
                Driver:addObject(bullet, EntityTypes.bullet)
              end
            end
          end
        end
      end
      _class_0.__parent.__init(self, x, y, sprite, 0, effect)
      self.name = "Double Shot"
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
