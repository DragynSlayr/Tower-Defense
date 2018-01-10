do
  local _class_0
  local _parent_0 = PassiveItem
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      local sprite = Sprite("item/movingTurret.tga", 32, 32, 1, 1.75)
      local effect
      effect = function(self, player)
        local multipliers = {
          -1,
          1
        }
        for k, t in pairs(player.turret) do
          local radius = t:getAttackHitBox().radius * 1
          if t.speed:getLength() == 0 then
            t.speed = Vector((pick(multipliers)) * player.max_speed * 0.5, (pick(multipliers)) * player.max_speed * 0.5)
          end
          if t.position.x - radius <= Screen_Size.border[1] or t.position.x + radius >= Screen_Size.border[3] then
            t.speed = Vector(t.speed.x * -1, t.speed.y)
          end
          if t.position.y - radius <= Screen_Size.border[2] or t.position.y + radius >= Screen_Size.border[4] + Screen_Size.border[2] then
            t.speed = Vector(t.speed.x, t.speed.y * -1)
          end
        end
      end
      _class_0.__parent.__init(self, sprite, 0, effect)
      self.name = "Moving Turret"
      self.description = "Your turret moves"
    end,
    __base = _base_0,
    __name = "MovingTurretPassive",
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
  MovingTurretPassive = _class_0
end
