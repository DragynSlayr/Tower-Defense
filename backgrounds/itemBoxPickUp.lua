do
  local _parent_0 = BackgroundObject
  local _base_0 = {
    update = function(self, dt)
      _parent_0.update(self, dt)
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          local player = p:getHitBox()
          local box = self:getHitBox()
          if player:contains(box) then
            Inventory.boxes = Inventory.boxes + 1
            self.health = 0
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  local _class_0 = setmetatable({
    __init = function(self, x, y)
      local sprite = Sprite("item/box.tga", 32, 32, 1, 1.75)
      return _parent_0.__init(self, x, y, sprite)
    end,
    __base = _base_0,
    __name = "ItemBoxPickUp",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        return _parent_0[name]
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
  ItemBoxPickUp = _class_0
end
