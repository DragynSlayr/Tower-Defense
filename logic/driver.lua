do
  local _class_0
  local _base_0 = {
    addObject = function(self, object, id)
      if self.objects[id] then
        self.objects[id][#self.objects[id] + 1] = object
        return Renderer:add(object, EntityTypes.layers[id])
      else
        self.objects[id] = { }
        return self:addObject(object, id)
      end
    end,
    removeObject = function(self, object, player_kill)
      if player_kill == nil then
        player_kill = true
      end
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          if object == o then
            Renderer:removeObject(object)
            if player_kill then
              v[k2]:kill()
              Objectives:entityKilled(v[k2])
            end
            v[k2] = nil
            break
          end
        end
      end
    end,
    killEnemies = function(self)
      if Driver.objects[EntityTypes.enemy] then
        for k, o in pairs(Driver.objects[EntityTypes.enemy]) do
          self:removeObject(o, false)
        end
      end
    end,
    isClear = function(self)
      local sum = 0
      for k, v in pairs(Driver.objects) do
        for k2, o in pairs(v) do
          if k ~= EntityTypes.player and k ~= EntityTypes.turret then
            sum = sum + 1
          end
        end
      end
      return sum == 0
    end,
    keypressed = function(key, scancode, isrepeat)
      if key == "escape" then
        return love.event.quit(0)
      elseif key == "p" then
        if Driver.game_state == Game_State.paused then
          Driver.game_state = Driver.last_state
        else
          Driver.last_state = Driver.game_state
          Driver.game_state = Game_State.paused
        end
      else
        if not (Driver.game_state == Game_State.paused or Driver.game_state == Game_State.game_over) then
          for k, v in pairs(Driver.objects[EntityTypes.player]) do
            v:keypressed(key)
          end
        end
      end
    end,
    keyreleased = function(key)
      if not (Driver.game_state == Game_State.paused or Driver.game_state == Game_State.game_over) then
        for k, v in pairs(Driver.objects[EntityTypes.player]) do
          v:keyreleased(key)
        end
      end
    end,
    mousepressed = function(x, y, button, isTouch)
      return UI:mousepressed(x, y, button, isTouch)
    end,
    mousereleased = function(x, y, button, isTouch)
      return UI:mousereleased(x, y, button, isTouch)
    end,
    focus = function(focus)
      if focus then
        Driver.game_state = Driver.last_state
      else
        Driver.last_state = Driver.game_state
        Driver.game_state = Game_State.paused
      end
      return UI:focus(focus)
    end,
    load = function(arg)
      UI:set_screen(Screen_State.main_menu)
      local start_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) - 32, 250, 60, "Start", function()
        Driver.game_state = Game_State.playing
        return UI:set_screen(Screen_State.none)
      end)
      UI:add(start_button)
      local exit_button = Button(Screen_Size.width / 2, (Screen_Size.height / 2) + 32, 250, 60, "Exit", function()
        return love.event.quit(0)
      end)
      UI:add(exit_button)
      local title = Text(Screen_Size.width / 2, (Screen_Size.height / 4), "Tower Defense")
      UI:add(title)
      local player = Player(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, Sprite("test.tga", 16, 16, 0.29, 4))
      player.sprite:setRotationSpeed(-math.pi / 2)
      Driver:addObject(player, EntityTypes.player)
      return Objectives:nextMode()
    end,
    update = function(dt)
      local _exp_0 = Driver.game_state
      if Game_State.game_over == _exp_0 then
        Driver.objects = nil
        Renderer.layers = nil
        return 
      elseif Game_State.paused == _exp_0 then
        return 
      elseif Game_State.playing == _exp_0 then
        for k, v in pairs(Driver.objects) do
          for k2, o in pairs(v) do
            o:update(dt)
            if o.health <= 0 or not o.alive then
              Driver:removeObject(o)
            end
          end
        end
        Objectives:update(dt)
      end
      return UI:update(dt)
    end,
    draw = function()
      love.graphics.push("all")
      UI:draw()
      local _exp_0 = Driver.game_state
      if Game_State.playing == _exp_0 then
        Renderer:drawAlignedMessage(SCORE .. "\t", 20, "right", Renderer.hud_font)
        Renderer:drawAll()
        Objectives:draw()
      elseif Game_State.paused == _exp_0 then
        Renderer:drawStatusMessage("PAUSED", love.graphics.getHeight() / 2, Renderer.giant_font)
      elseif Game_State.game_over == _exp_0 then
        Renderer:drawStatusMessage("YOU DIED!", love.graphics.getHeight() / 2, Renderer.giant_font)
      end
      love.graphics.pop()
      local before = math.floor(collectgarbage("count"))
      collectgarbage("step")
      local after = math.floor(collectgarbage("count"))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.objects = { }
      self.game_state = Game_State.none
      self.last_state = self.game_state
      love.keypressed = self.keypressed
      love.keyreleased = self.keyreleased
      love.mousepressed = self.mousepressed
      love.mousereleased = self.mousereleased
      love.focus = self.focus
      love.load = self.load
      love.update = self.update
      love.draw = self.draw
    end,
    __base = _base_0,
    __name = "Driver"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Driver = _class_0
end
