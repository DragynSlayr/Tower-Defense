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
      local found = false
      for k, v in pairs(Driver.objects) do
        if not found then
          for k2, o in pairs(v) do
            if object == o then
              Renderer:removeObject(object)
              if player_kill then
                if math.random() <= o.item_drop_chance then
                  local box = ItemBox(o.position.x, o.position.y)
                  Driver:addObject(box, EntityTypes.item)
                end
                v[k2]:kill()
                Objectives:entityKilled(v[k2])
              end
              table.remove(Driver.objects[k], k2)
              found = true
              break
            end
          end
        end
      end
    end,
    clearObjects = function(self, typeof)
      if Driver.objects[typeof] then
        local objects = { }
        for k, o in pairs(Driver.objects[typeof]) do
          objects[#objects + 1] = o
        end
        for k, o in pairs(objects) do
          Driver:removeObject(o, false)
        end
      end
    end,
    killEnemies = function(self)
      Driver:clearObjects(EntityTypes.enemy)
      return Driver:clearObjects(EntityTypes.bullet)
    end,
    respawnPlayers = function(self)
      if Driver.objects[EntityTypes.player] then
        for k, p in pairs(Driver.objects[EntityTypes.player]) do
          local p2 = Player(p.position.x, p.position.y)
          for k, i in pairs(p.equipped_items) do
            i:pickup(p2)
          end
          Driver:removeObject(p, false)
          Driver:addObject(p2, EntityTypes.player)
        end
      end
    end,
    isClear = function(self)
      local sum = 0
      if Driver.objects[EntityTypes.enemy] then
        for k, v in pairs(Driver.objects[EntityTypes.enemy]) do
          if v.alive then
            sum = sum + 1
          end
        end
      end
      if Driver.objects[EntityTypes.bullet] then
        for k, b in pairs(Driver.objects[EntityTypes.bullet]) do
          if b.alive then
            sum = sum + 1
          end
        end
      end
      return sum == 0
    end,
    getRandomPosition = function(self)
      local x = math.random(Screen_Size.border[1], Screen_Size.border[3])
      local y = math.random(Screen_Size.border[2], Screen_Size.border[4])
      return Point(x, y)
    end,
    quitGame = function()
      ScoreTracker:saveScores()
      return love.event.quit(0)
    end,
    keypressed = function(key, scancode, isrepeat)
      if key == "escape" then
        Driver.quitGame()
      elseif key == "printscreen" then
        local screenshot = love.graphics.newScreenshot(true)
        screenshot:encode("png", "screenshots/" .. os.time() .. ".png")
      end
      if DEBUG_MENU then
        if DEBUG_MENU_ENABLED then
          if key == "`" then
            DEBUG_MENU = false
          else
            return Debugger:keypressed(key, scancode, isrepeat)
          end
        end
      else
        if key == "`" then
          if DEBUG_MENU_ENABLED then
            DEBUG_MENU = true
          end
        elseif key == "p" then
          if not Driver.game_state == Game_State.game_over then
            if Driver.game_state == Game_State.paused then
              return Driver.unpause()
            else
              return Driver.pause()
            end
          end
        else
          local _exp_0 = Driver.game_state
          if Game_State.playing == _exp_0 then
            if Objectives.mode.complete and key == "space" then
              Objectives.ready = true
            else
              for k, v in pairs(Driver.objects[EntityTypes.player]) do
                v:keypressed(key)
              end
            end
          elseif Game_State.game_over == _exp_0 then
            return GameOver:keypressed(key, scancode, isrepeat)
          end
        end
      end
    end,
    keyreleased = function(key)
      if DEBUG_MENU then
        return Debugger:keyreleased(key)
      else
        local _exp_0 = Driver.game_state
        if Game_State.playing == _exp_0 then
          for k, v in pairs(Driver.objects[EntityTypes.player]) do
            v:keyreleased(key)
          end
        elseif Game_State.game_over == _exp_0 then
          return GameOver:keyreleased(key)
        end
      end
    end,
    mousepressed = function(x, y, button, isTouch)
      if DEBUG_MENU then
        return Debugger:mousepressed(x, y, button, isTouch)
      else
        UI:mousepressed(x, y, button, isTouch)
        local _exp_0 = Driver.game_state
        if Game_State.game_over == _exp_0 then
          return GameOver:mousepressed(x, y, button, isTouch)
        end
      end
    end,
    mousereleased = function(x, y, button, isTouch)
      if DEBUG_MENU then
        return Debugger:mousereleased(x, y, button, isTouch)
      else
        UI:mousereleased(x, y, button, isTouch)
        local _exp_0 = Driver.game_state
        if Game_State.game_over == _exp_0 then
          return GameOver:mousereleased(x, y, button, isTouch)
        end
      end
    end,
    textinput = function(text)
      if DEBUG_MENU then
        return Debugger:textinput(text)
      else
        UI:textinput(text)
        local _exp_0 = Driver.game_state
        if Game_State.game_over == _exp_0 then
          return GameOver:textinput(text)
        end
      end
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
      Inventory:set_message()
      Driver.state_stack:add(Driver.game_state)
      Driver.game_state = Game_State.paused
      for k, o in pairs(Driver.objects[EntityTypes.player]) do
        o.keys_pushed = 0
      end
      UI.state_stack:add(UI.current_screen)
      return UI:set_screen(Screen_State.pause_menu)
    end,
    unpause = function()
      Inventory:set_message()
      Driver.game_state = Driver.state_stack:remove()
      return UI:set_screen(UI.state_stack:remove())
    end,
    game_over = function()
      Driver.game_state = Game_State.game_over
      return UI:set_screen(Screen_State.game_over)
    end,
    restart = function()
      loadBaseStats()
      ScoreTracker = Score()
      love.graphics.setDefaultFilter("nearest", "nearest", 1)
      MusicPlayer = MusicHandler()
      Renderer = ObjectRenderer()
      Driver.objects = { }
      Driver.game_state = Game_State.none
      Driver.state_stack = Stack()
      Driver.state_stack:add(Game_State.main_menu)
      Driver.elapsed = 0
      Driver.shader = nil
      UI = UIHandler()
      Debugger = DebugMenu()
      Objectives = ObjectivesHandler()
      ItemPool = ItemPoolHandler()
      Upgrade = UpgradeScreen()
      Inventory = InventoryScreen()
      Pause = PauseScreen()
      GameOver = GameOverScreen()
      ScreenCreator()
      Map = MapCreator()
      Objectives:spawn(EntityTypes.player, 0, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
      return Objectives:nextMode()
    end,
    load = function(arg)
      return Driver.restart()
    end,
    update = function(dt)
      if DEBUG_MENU then
        return Debugger:update(dt)
      else
        Driver.elapsed = Driver.elapsed + dt
        local _exp_0 = Driver.game_state
        if Game_State.game_over == _exp_0 then
          GameOver:update(dt)
        elseif Game_State.paused == _exp_0 then
          Pause:update(dt)
        elseif Game_State.upgrading == _exp_0 then
          Upgrade:update(dt)
        elseif Game_State.inventory == _exp_0 then
          Inventory:update(dt)
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
        UI:update(dt)
        ScoreTracker:update(dt)
        if not Driver.shader then
          Driver.shader = love.graphics.newShader("shaders/normal.fs")
        end
      end
    end,
    draw = function()
      love.graphics.push("all")
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none then
        love.graphics.setShader(Driver.shader)
      end
      love.graphics.setColor(75, 163, 255, 255)
      love.graphics.rectangle("fill", 0, 0, Screen_Size.width, Screen_Size.height)
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none then
        love.graphics.setShader()
      end
      love.graphics.pop()
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
        Renderer:drawAlignedMessage(ScoreTracker.score .. "\t", 20 * Scale.height, "right", Renderer.hud_font)
        Renderer:drawAll()
        Objectives:draw()
      elseif Game_State.upgrading == _exp_0 then
        Upgrade:draw()
      elseif Game_State.inventory == _exp_0 then
        Inventory:draw()
      elseif Game_State.paused == _exp_0 then
        Pause:draw()
      elseif Game_State.game_over == _exp_0 then
        GameOver:draw()
      end
      love.graphics.setColor(0, 0, 0, 127)
      love.graphics.setFont(Renderer.small_font)
      love.graphics.printf(VERSION .. "\t", 0, Screen_Size.height - (25 * Scale.height), Screen_Size.width, "right")
      love.graphics.printf(love.timer.getFPS() .. " FPS\t", 0, Screen_Size.height - (50 * Scale.height), Screen_Size.width, "right")
      love.graphics.pop()
      if DEBUG_MENU then
        Debugger:draw()
      end
      return collectgarbage("step")
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      love.keypressed = self.keypressed
      love.keyreleased = self.keyreleased
      love.mousepressed = self.mousepressed
      love.mousereleased = self.mousereleased
      love.textinput = self.textinput
      love.focus = self.focus
      love.load = self.load
      love.update = self.update
      love.draw = self.draw
      love.filesystem.setIdentity("Tower Defense")
      love.filesystem.createDirectory("screenshots")
      if not love.filesystem.exists("SETTINGS") then
        love.filesystem.write("SETTINGS", "MODS_ENABLED 0")
      end
      local MODS_ENABLED = readKey("MODS_ENABLED")
      local FILES_DUMPED = readKey("FILES_DUMPED")
      if MODS_ENABLED and not FILES_DUMPED then
        print("DUMPING FILES")
        local dirs = getAllDirectories("assets")
        for k, v in pairs(dirs) do
          love.filesystem.createDirectory("mods/" .. v)
        end
        local files = getAllFiles("assets")
        for k, v in pairs(files) do
          if not love.filesystem.exists("mods/" .. v) then
            print("DUMPING " .. v)
            local contents, size = love.filesystem.read(v)
            love.filesystem.write("mods/" .. v, contents)
          end
        end
        print("FILES DUMPED")
        writeKey("FILES_DUMPED", "1")
      end
      if MODS_ENABLED then
        PATH_PREFIX = "mods/"
      else
        PATH_PREFIX = ""
      end
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
