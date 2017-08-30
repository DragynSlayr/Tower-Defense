do
  local _class_0
  local _parent_0 = GameObject
  local _base_0 = {
    getRandomRarity = function(self)
      local blackChance = 50
      local greenChance = 26
      local blueChance = 15
      local purpleChance = 8
      local orangeChance = 1
      local num = math.random() * 100
      if num > blackChance + greenChance + blueChance + purpleChance then
        return 5
      elseif num > blackChance + greenChance + blueChance then
        return 4
      elseif num > blackChance + greenChance then
        return 3
      elseif num > blackChance then
        return 2
      else
        return 1
      end
    end,
    getStats = function(self)
      local stats = { }
      table.insert(stats, self.name)
      table.insert(stats, self.description)
      return stats
    end,
    pickup = function(self, player)
      table.insert(player.equipped_items, self)
      self.collectable = false
      self.contact_damage = false
      self.solid = false
      self.player = player
      return print("Equipped " .. self.name)
    end,
    unequip = function(self, player)
      for k, i in pairs(player.equipped_items) do
        if i.name == self.name then
          table.remove(player.equipped_items, k)
          local successful = true
          break
        end
      end
      return print("Unequipped " .. self.name)
    end,
    use = function(self) end,
    update2 = function(self, dt)
      self.timer = self.timer + dt
    end,
    update = function(self, dt)
      if self.collectable then
        return _class_0.__parent.__base.update(self, dt)
      else
        return self:update2(dt)
      end
    end,
    draw2 = function(self) end,
    draw = function(self)
      if self.collectable then
        return _class_0.__parent.__base.draw(self)
      else
        return self:draw2()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite)
      _class_0.__parent.__init(self, x, y, sprite)
      self.item_type = nil
      self.collectable = true
      self.draw_health = false
      self.contact_damage = true
      self.id = EntityTypes.item
      self.player = nil
      self.timer = 0
      self.solid = true
      self.damage = 0
      self.name = "No name"
      self.description = "No description"
      if not self.rarity then
        self.rarity = 1
      end
    end,
    __base = _base_0,
    __name = "Item",
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
  local self = _class_0
  self.probability = 1
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Item = _class_0
end
