do
  local _class_0
  local _base_0 = {
    newFont = function(self, size)
      return love.graphics.newFont(PATH_PREFIX .. "assets/fonts/opsb.ttf", size * Scale.height)
    end,
    add = function(self, object, layer)
      if self.layers[layer] then
        self.layers[layer][#self.layers[layer] + 1] = object
      else
        self.layers[layer] = { }
        return self:add(object, layer)
      end
    end,
    removeObject = function(self, object)
      local found = false
      for k, layer in pairs(self.layers) do
        if not found then
          for i, o in pairs(layer) do
            if object == o then
              table.remove(self.layers[k], i)
              found = true
              break
            end
          end
        end
      end
    end,
    enqueue = function(self, func)
      self.queue[#self.queue + 1] = func
    end,
    drawAll = function(self)
      love.graphics.push("all")
      for k, layer in pairs(self.layers) do
        for i, object in pairs(layer) do
          object:draw()
        end
      end
      for k, func in pairs(self.queue) do
        func()
      end
      self.queue = { }
      return love.graphics.pop()
    end,
    drawHUDMessage = function(self, message, x, y, font, color)
      if font == nil then
        font = self.hud_font
      end
      if color == nil then
        color = Color()
      end
      love.graphics.push("all")
      love.graphics.setShader()
      love.graphics.setColor(color:get())
      love.graphics.setFont(font)
      love.graphics.print(message, x, y)
      return love.graphics.pop()
    end,
    drawStatusMessage = function(self, message, y, font, color)
      if y == nil then
        y = 0
      end
      if font == nil then
        font = self.status_font
      end
      if color == nil then
        color = Color()
      end
      return self:drawAlignedMessage(message, y, "center", font, color)
    end,
    drawAlignedMessage = function(self, message, y, alignment, font, color)
      if alignment == nil then
        alignment = "center"
      end
      if font == nil then
        font = self.status_font
      end
      if color == nil then
        color = Color()
      end
      love.graphics.push("all")
      love.graphics.setShader()
      love.graphics.setColor(color:get())
      love.graphics.setFont(font)
      love.graphics.printf(message, 0, y - (font:getHeight() / 2), love.graphics:getWidth(), alignment)
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.queue = { }
      self.layers = { }
      self.giant_font = love.graphics.newFont(PATH_PREFIX .. "assets/fonts/opsb.ttf", 250 * Scale.height)
      self.title_font = love.graphics.newFont(PATH_PREFIX .. "assets/fonts/opsb.ttf", 70 * Scale.height)
      self.status_font = love.graphics.newFont(PATH_PREFIX .. "assets/fonts/opsb.ttf", 50 * Scale.height)
      self.hud_font = love.graphics.newFont(PATH_PREFIX .. "assets/fonts/opsb.ttf", 30 * Scale.height)
      self.small_font = love.graphics.newFont(PATH_PREFIX .. "assets/fonts/opsb.ttf", 20 * Scale.height)
      for i = 1, 10 do
        self.layers[i] = { }
      end
    end,
    __base = _base_0,
    __name = "ObjectRenderer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ObjectRenderer = _class_0
end
