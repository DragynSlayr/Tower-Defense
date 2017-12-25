do
  local _class_0
  local _parent_0 = ActiveItem
  local _base_0 = {
    createDragon = function(self, x, y, r, f)
      if r == nil then
        r = -1
      end
      if f == nil then
        f = false
      end
      local dragon = PoisonField(x, y)
      dragon.sprite = Sprite("background/dragonStrike.tga", 32, 32, 1, 6)
      dragon.sprite.color[4] = 200
      dragon.sprite:setRotationSpeed(math.pi / (3 * r))
      if f then
        dragon.sprite.x_scale = dragon.sprite.x_scale * -1
      end
      dragon.life_time = 6
      dragon.poison_amount = 1
      return Driver:addObject(dragon, EntityTypes.background)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.rarity = self:getRandomRarity()
      local cd = ({
        18,
        16,
        14,
        12,
        10
      })[self.rarity]
      local sprite = Sprite("item/dragonStrikeActive.tga", 32, 32, 1, 1.75)
      sprite:setRotationSpeed(-math.pi / 3)
      local effect
      effect = function(self, player)
        if player.speed:getLength() == 0 then
          for i = 0, 300, 60 do
            local x = 138 * Scale.width
            local v = Vector(x, 0)
            v:rotate((i / 180) * math.pi)
            v:add(player.position)
            local y
            x, y = v:getComponents()
            local r = -1
            local f = false
            if (i / 60) % 2 == 1 then
              r = 1
              f = true
            end
            self:createDragon(x, y, r, f)
          end
        else
          local angle = player.speed:getAngle()
          for i = 1, 6 do
            local x = (i - 1) * (96 * Scale.width)
            local v = Vector(x, 0)
            v:rotate(angle)
            v:add(player.position)
            self:createDragon(v:getComponents())
          end
        end
      end
      _class_0.__parent.__init(self, sprite, cd, effect)
      self.name = "Dragon Strike"
      self.description = "Summon a dragon"
      self.effect_time = 6
    end,
    __base = _base_0,
    __name = "DragonStrikeActive",
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
  DragonStrikeActive = _class_0
end
