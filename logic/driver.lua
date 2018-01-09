do
  local _base_0 = {
    addObject = function(self, object, id)
      if self.objects[id] then
        self.objects[id][#self.objects[id] + 1] = object
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
              if player_kill then
                for k, player in pairs(Driver.objects[EntityTypes.player]) do
                  player.exp = player.exp + o.exp_given
                end
                if Driver.box_counter < Driver.max_boxes and math.random() <= o.item_drop_chance then
                  Driver.box_counter = Driver.box_counter + 1
                  local box = ItemBoxPickUp(o.position.x, o.position.y)
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
    clearAll = function(self, excluded)
      if excluded == nil then
        excluded = {
          EntityTypes.player
        }
      end
      for k, v in pairs(Driver.objects) do
        if not tableContains(excluded, k) then
          Driver:clearObjects(k)
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
          local p2 = Player(Screen_Size.half_width, Screen_Size.half_height)
          for k, i in pairs(p.equipped_items) do
            i:pickup(p2)
          end
          p2.exp = p.exp
          p2.level = p.level
          Driver:removeObject(p, false)
          Driver:addObject(p2, EntityTypes.player)
        end
      end
    end,
    isClear = function(self, count_enemies, count_bullets)
      if count_enemies == nil then
        count_enemies = true
      end
      if count_bullets == nil then
        count_bullets = true
      end
      local sum = 0
      if count_enemies then
        if Driver.objects[EntityTypes.enemy] then
          for k, v in pairs(Driver.objects[EntityTypes.enemy]) do
            if v.alive then
              sum = sum + 1
            end
          end
        end
      end
      if count_bullets then
        if Driver.objects[EntityTypes.bullet] then
          for k, b in pairs(Driver.objects[EntityTypes.bullet]) do
            if b.alive then
              sum = sum + 1
            end
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
      ScoreTracker:disconnect()
      ScoreTracker:saveScores()
      return love.event.quit(0)
    end,
    keypressed = function(key, scancode, isrepeat)
      if key == "printscreen" then
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
        elseif key == Controls.keys.PAUSE_GAME then
          if Driver.game_state ~= Game_State.game_over then
            if Driver.game_state == Game_State.paused then
              return Driver.unpause()
            else
              return Driver.pause()
            end
          end
        else
          UI:keypressed(key, scancode, isrepeat)
          local _exp_0 = Driver.game_state
          if Game_State.playing == _exp_0 then
            if Objectives.mode.complete and key == Controls.keys.USE_TURRET then
              Driver.box_counter = 0
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
        UI:keyreleased(key)
        local _exp_0 = Driver.game_state
        if Game_State.playing == _exp_0 then
          for k, v in pairs(Driver.objects[EntityTypes.player]) do
            v:keyreleased(key)
          end
        elseif Game_State.game_over == _exp_0 then
          return GameOver:keyreleased(key)
        elseif Game_State.controls == _exp_0 then
          return Controls:keyreleased(key)
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
      Inventory:set_item()
      Driver.state_stack:add(Driver.game_state)
      Driver.game_state = Game_State.paused
      for k, o in pairs(Driver.objects[EntityTypes.player]) do
        o.keys_pushed = 0
      end
      UI.state_stack:add(UI.current_screen)
      return UI:set_screen(Screen_State.pause_menu)
    end,
    unpause = function()
      Inventory:set_item()
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
      Driver.box_counter = 0
      Driver.max_boxes = 5
      UI = UIHandler()
      Debugger = DebugMenu()
      Objectives = ObjectivesHandler()
      ItemPool = ItemPoolHandler()
      Controls = ControlsHandler()
      Upgrade = UpgradeScreen()
      Inventory = InventoryScreen()
      Pause = PauseScreen()
      GameOver = GameOverScreen()
      ScreenCreator()
      Map = MapCreator()
      Objectives:spawn((Player), EntityTypes.player, 0, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
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
        elseif Game_State.controls == _exp_0 then
          Controls:update(dt)
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
        if DEBUGGING then
          local y = 100
          for k, layer in pairs(EntityTypes.order) do
            local message = layer .. ": "
            if Driver.objects[layer] then
              message = message .. #Driver.objects[layer]
            else
              message = message .. 0
            end
            Renderer:drawAlignedMessage(message, y, "left", Renderer.small_font, (Color(255, 255, 255)))
            y = y + 25
          end
        end
      elseif Game_State.upgrading == _exp_0 then
        Upgrade:draw()
        UI:draw({
          TooltipBox
        })
      elseif Game_State.inventory == _exp_0 then
        Inventory:draw()
      elseif Game_State.controls == _exp_0 then
        Controls:draw()
      elseif Game_State.paused == _exp_0 then
        Pause:draw()
      elseif Game_State.game_over == _exp_0 then
        GameOver:draw()
      end
      love.graphics.setColor(0, 0, 0, 127)
      love.graphics.setFont(Renderer.small_font)
      love.graphics.printf(VERSION .. "\t", 0, Screen_Size.height - (25 * Scale.height), Screen_Size.width, "right")
      if SHOW_FPS then
        love.graphics.printf(love.timer.getFPS() .. " FPS\t", 0, Screen_Size.height - (50 * Scale.height), Screen_Size.width, "right")
      end
      love.graphics.pop()
      if DEBUG_MENU then
        Debugger:draw()
      end
      return collectgarbage("step")
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
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
        local defaults = "MODS_ENABLED 0\n"
        defaults = defaults .. "FILES_DUMPED 0\n"
        defaults = defaults .. "FULLSCREEN 1\n"
        defaults = defaults .. ("WIDTH " .. love.graphics.getWidth() .. "\n")
        defaults = defaults .. ("HEIGHT " .. love.graphics.getHeight() .. "\n")
        defaults = defaults .. "VSYNC 0\n"
        defaults = defaults .. "SHOW_FPS 0\n"
        defaults = defaults .. "MOVE_UP w\n"
        defaults = defaults .. "MOVE_DOWN s\n"
        defaults = defaults .. "MOVE_LEFT a\n"
        defaults = defaults .. "MOVE_RIGHT d\n"
        defaults = defaults .. "SHOOT_UP up\n"
        defaults = defaults .. "SHOOT_DOWN down\n"
        defaults = defaults .. "SHOOT_LEFT left\n"
        defaults = defaults .. "SHOOT_RIGHT right\n"
        defaults = defaults .. "USE_ITEM q\n"
        defaults = defaults .. "PAUSE_GAME escape\n"
        defaults = defaults .. "SHOW_RANGE z\n"
        defaults = defaults .. "TOGGLE_TURRET e\n"
        defaults = defaults .. "USE_TURRET space"
        love.filesystem.write("SETTINGS", defaults)
      end
      local MODS_ENABLED = (readKey("MODS_ENABLED")) == "1"
      local FILES_DUMPED = (readKey("FILES_DUMPED")) == "1"
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
      SHOW_FPS = (readKey("SHOW_FPS")) == "1"
      local flags = { }
      flags.fullscreen = (readKey("FULLSCREEN")) == "1"
      flags.vsync = (readKey("VSYNC")) == "1"
      local width = tonumber((readKey("WIDTH")))
      local height = tonumber((readKey("HEIGHT")))
      local current_width, current_height, current_flags = love.window.getMode()
      local num_diff = 0
      if flags.fullscreen ~= current_flags.fullscreen then
        num_diff = num_diff + 1
      end
      if flags.vsync ~= current_flags.vsync then
        num_diff = num_diff + 1
      end
      if width ~= current_width then
        num_diff = num_diff + 1
      end
      if height ~= current_height then
        num_diff = num_diff + 1
      end
      if num_diff > 0 then
        love.window.setMode(width, height, flags)
      end
      calcScreen()
      KEY_CHANGED = true
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
