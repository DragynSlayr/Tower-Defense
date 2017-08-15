do
  local _class_0
  local _parent_0 = Screen
  local _base_0 = {
    createMenu = function(self)
      local x = (Screen_Size.width / 2) - (250 * Scale.width)
      local y = Screen_Size.height - (120 * Scale.height)
      local width = 370 * Scale.width
      local height = 50 * Scale.height
      local submit_box = TextBox(x, y, width, height)
      submit_box.action = { }
      submit_box.font = Renderer:newFont(25)
      submit_box.text_color = {
        255,
        255,
        255,
        255
      }
      self:add(submit_box)
      x = (Screen_Size.width / 2) + (190 * Scale.width)
      y = Screen_Size.height - (95 * Scale.height)
      local submit_button = Button(x, y, 125, 50, "Submit", function(self)
        self.active = false
        ScoreTracker:submitScore(submit_box:getText())
        return submit_box:resetText()
      end)
      return self:add(submit_button)
    end,
    add = function(self, object)
      return table.insert(self.ui_objects, object)
    end,
    keypressed = function(self, key, scancode, isrepeat)
      for k, v in pairs(self.ui_objects) do
        v:keypressed(key, scancode, isrepeat)
      end
    end,
    keyreleased = function(self, key)
      for k, v in pairs(self.ui_objects) do
        v:keyreleased(key)
      end
    end,
    mousepressed = function(self, x, y, button, isTouch)
      for k, v in pairs(self.ui_objects) do
        v:mousepressed(x, y, button, isTouch)
      end
    end,
    mousereleased = function(self, x, y, button, isTouch)
      for k, v in pairs(self.ui_objects) do
        v:mousereleased(x, y, button, isTouch)
      end
    end,
    textinput = function(self, text)
      for k, v in pairs(self.ui_objects) do
        v:textinput(text)
      end
    end,
    update = function(self, dt)
      for k, v in pairs(self.ui_objects) do
        v:update(dt)
      end
    end,
    draw = function(self)
      for k, v in pairs(self.ui_objects) do
        v:draw()
      end
      Renderer:drawAlignedMessage("Score: " .. ScoreTracker.score, 270 * Scale.height)
      love.graphics.push("all")
      local x_start = 400
      local x = x_start * Scale.width
      local y_start = 300 * Scale.height
      local y = y_start
      local width = Screen_Size.width - (x_start * 2 * Scale.width)
      local height = 475 * Scale.height
      love.graphics.setColor(0, 0, 0, 127)
      love.graphics.rectangle("fill", x, y, width, height)
      love.graphics.setColor(0, 255, 255, 255)
      love.graphics.setFont(Renderer.hud_font)
      local gap = 20
      ScoreTracker.high_scores:sort()
      for k, node in pairs(ScoreTracker.high_scores.elements) do
        if y - y_start < height then
          love.graphics.printf(node.name, x + (gap * Scale.width), y, width - (2 * gap * Scale.width), "left")
          love.graphics.printf(node.score, x + (gap * Scale.width), y, width - (2 * gap * Scale.width), "right")
          y = y + (Renderer.hud_font:getHeight() + (5 * Scale.height))
        end
      end
      return love.graphics.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.ui_objects = { }
      return self:createMenu()
    end,
    __base = _base_0,
    __name = "GameOverScreen",
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
  GameOverScreen = _class_0
end
