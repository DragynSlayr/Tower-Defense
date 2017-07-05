do
  local _class_0
  local _parent_0 = Item
  local _base_0 = {
    use = function(self)
      if self.charged then
        self.timer = 0
        self.charged = false
        return self:effect(self.player)
      else
        return print("On Cooldown: " .. math.floor((self.charge_time - self.timer)))
      end
    end,
    draw2 = function(self)
      love.graphics.push("all")
      love.graphics.setColor(0, 0, 0, 255)
      local message = "Ready"
      if not self.charged then
        message = math.ceil((self.charge_time - self.timer))
      end
      Renderer:drawHUDMessage(message, Screen_Size.width * 0.2, Screen_Size.height - (50 * Scale.height), Renderer.hud_font)
      return love.graphics.pop()
    end,
    update2 = function(self, dt)
      _class_0.__parent.__base.update2(self, dt)
      if not self.charged and self.timer >= self.charge_time then
        self.timer = 0
        self.charged = true
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, sprite, charge_time, effect)
      if charge_time == nil then
        charge_time = 0
      end
      _class_0.__parent.__init(self, x, y, sprite)
      self.item_type = ItemTypes.active
      self.charged = true
      self.charge_time = charge_time
      self.effect = effect
    end,
    __base = _base_0,
    __name = "ActiveItem",
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
  ActiveItem = _class_0
end
