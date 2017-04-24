do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.player = "Player"
      self.turret = "Turret"
      self.enemy = "Enemy"
      self.item = "Item"
      self.health = "Health"
      self.coin = "Coin"
      self.layers = { }
      self.layers[self.player] = 4
      self.layers[self.turret] = 1
      self.layers[self.enemy] = 3
      self.layers[self.item] = 2
      self.layers[self.health] = 2
      self.layers[self.coin] = 2
    end,
    __base = _base_0,
    __name = "EntityTypes"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  EntityTypes = _class_0
end
