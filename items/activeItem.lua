do
  local _class_0
  local _parent_0 = Item
  local _base_0 = {
    getStats = function(self)
      local stats = _class_0.__parent.__base.getStats(self)
      table.insert(stats, "Cooldown: " .. self.charge_time .. "s")
      return stats
    end,
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
      local x = ((Screen_Size.width / 2) + (10 * Scale.width)) / 2
      local y = Screen_Size.height - (35 * Scale.height)
      if self.charged then
        love.graphics.setColor(132, 87, 15, 200)
      else
        love.graphics.setColor(15, 87, 132, 200)
      end
      love.graphics.rectangle("fill", x - (60 * Scale.width * 0.5), y - (60 * Scale.height * 0.5), 60 * Scale.width, 60 * Scale.height)
      self.sprite:draw(x, y)
      if not self.charged then
        love.graphics.setColor(0, 0, 0, 127)
        local font = Renderer.hud_font
        love.graphics.setFont(font)
        local message = math.ceil((self.charge_time - self.timer))
        love.graphics.printf(message, x + (60 * Scale.width * 0.5), y - (font:getHeight() / 2), 60 * Scale.width, "center")
      end
      return love.graphics.pop()
    end,
    update2 = function(self, dt)
      _class_0.__parent.__base.update2(self, dt)
      if not self.charged and self.timer >= self.charge_time then
        self.timer = 0
        self.charged = true
      end
      local amount = 0
      if not self.charged then
        amount = 1 - (self.timer / self.charge_time)
      end
      return self.sprite.shader:send("amount", amount)
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
      return self.sprite:setShader(love.graphics.newShader("shaders/active_item_shader.fs"))
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
