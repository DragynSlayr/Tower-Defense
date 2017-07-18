do
  local _class_0
  local _parent_0 = PassiveItem
  local _base_0 = {
    pickup = function(self, player)
      _class_0.__parent.__base.pickup(self, player)
      self.last_health = player.health
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/damageReflectPassive.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local health = player.health
        if health < self.last_health then
          local difference = self.last_health - health
          self.last_health = health
          if math.random() >= 0.5 then
            local filters = {
              EntityTypes.enemy,
              EntityTypes.player
            }
            for k2, typeof in pairs(filters) do
              if Driver.objects[typeof] then
                for k, e in pairs(Driver.objects[typeof]) do
                  local enemy = e:getHitBox()
                  local p = player:getHitBox()
                  p.radius = p.radius + (player.attack_range + player.range_boost)
                  if p:contains(enemy) then
                    local temp_damage = player.damage
                    player.damage = difference
                    e:onCollide(player)
                    player.damage = temp_damage
                  end
                end
              end
            end
          end
        end
      end
      _class_0.__parent.__init(self, x, y, sprite, 0, effect)
      self.name = "Damage Reflect"
      self.description = "Has a chance to reflect damage taken"
    end,
    __base = _base_0,
    __name = "DamageReflectPassive",
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
  DamageReflectPassive = _class_0
end
