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
      if Driver.objects[EntityTypes.bullet] then
        for k, b in pairs(Driver.objects[EntityTypes.bullet]) do
          self:removeObject(b, false)
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
          return Driver.unpause()
        else
          return Driver.pause()
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
        Driver.unpause()
      else
        Driver.pause()
      end
      return UI:focus(focus)
    end,
    pause = function()
      Driver.state_stack:add(Driver.game_state)
      Driver.game_state = Game_State.paused
      for k, o in pairs(Driver.objects[EntityTypes.player]) do
        o.keys_pushed = 0
      end
      UI.state_stack:add(UI.current_screen)
      return UI:set_screen(Screen_State.pause_menu)
    end,
    unpause = function()
      Driver.game_state = Driver.state_stack:remove()
      return UI:set_screen(UI.state_stack:remove())
    end,
    game_over = function()
      Driver.game_state = Game_State.game_over
      return UI:set_screen(Screen_State.game_over)
    end,
    load = function(arg)
      Driver.shader = love.graphics.newShader("shaders/normal.fs")
      ScreenCreator()
      local player = Player(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, Sprite("test.tga", 16, 16, 0.29, 4))
      player.sprite:setRotationSpeed(-math.pi / 2)
      Driver:addObject(player, EntityTypes.player)
      return Objectives:nextMode()
    end,
    update = function(dt)
      Driver.elapsed = Driver.elapsed + dt
      local _exp_0 = Driver.game_state
      if Game_State.game_over == _exp_0 then
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
      elseif Game_State.upgrading == _exp_0 then
        Upgrade:update(dt)
      end
      return UI:update(dt)
    end,
    draw = function()
      love.graphics.push("all")
      UI:draw()
      local _exp_0 = Driver.game_state
      if Game_State.playing == _exp_0 then
        love.graphics.push("all")
        love.graphics.setColor(15, 87, 132, 200)
        local bounds = Screen_Size.border
        love.graphics.rectangle("fill", 0, 0, bounds[3], bounds[2])
        love.graphics.rectangle("fill", 0, bounds[2] + bounds[4], bounds[3], bounds[2])
        love.graphics.pop()
        Renderer:drawAlignedMessage(SCORE .. "\t", 20, "right", Renderer.hud_font)
        love.graphics.setShader(Driver.shader)
        Renderer:drawAll()
        Objectives:draw()
        love.graphics.setShader()
      elseif Game_State.upgrading == _exp_0 then
        Upgrade:draw()
      end
      if DEBUGGING then
        love.graphics.setColor(200, 200, 200, 100)
        local bounds = Screen_Size.border
        love.graphics.rectangle("fill", bounds[1], bounds[2], bounds[3], bounds[4])
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
      self.state_stack = Stack()
      self.state_stack:add(Game_State.main_menu)
      self.elapsed = 0
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
