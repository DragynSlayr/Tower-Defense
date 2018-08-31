export class Driver
    new: =>
      love.keypressed = @keypressed
      love.keyreleased = @keyreleased
      love.mousepressed = @mousepressed
      love.mousereleased = @mousereleased
      love.textinput = @textinput
      love.focus = @focus
      love.load = @load
      love.update = @update
      love.draw = @draw

      love.filesystem.setIdentity "Tower Defense"
      love.filesystem.createDirectory "screenshots"

      if not love.filesystem.getInfo "SETTINGS"
        defaults = "MODS_ENABLED 0\n"
        defaults ..= "FILES_DUMPED 0\n"
        defaults ..= "FULLSCREEN 1\n"
        defaults ..= "WIDTH " .. love.graphics.getWidth! .. "\n"
        defaults ..= "HEIGHT " .. love.graphics.getHeight! .. "\n"
        defaults ..= "VSYNC 0\n"
        defaults ..= "SHOW_FPS 0\n"
        defaults ..= "MOVE_UP w\n"
        defaults ..= "MOVE_DOWN s\n"
        defaults ..= "MOVE_LEFT a\n"
        defaults ..= "MOVE_RIGHT d\n"
        defaults ..= "SHOOT_UP up\n"
        defaults ..= "SHOOT_DOWN down\n"
        defaults ..= "SHOOT_LEFT left\n"
        defaults ..= "SHOOT_RIGHT right\n"
        defaults ..= "USE_ITEM q\n"
        defaults ..= "PAUSE_GAME escape\n"
        defaults ..= "SHOW_RANGE z\n"
        defaults ..= "TOGGLE_TURRET e\n"
        defaults ..= "USE_TURRET space"
        love.filesystem.write "SETTINGS", defaults

      MODS_ENABLED = (readKey "MODS_ENABLED") == "1"
      FILES_DUMPED = (readKey "FILES_DUMPED") == "1"

      if MODS_ENABLED and not FILES_DUMPED
        print "DUMPING FILES"

        dirs = getAllDirectories "assets"
        for k, v in pairs dirs
          love.filesystem.createDirectory "mods/" .. v

        files = getAllFiles "assets"
        for k, v in pairs files
          if not love.filesystem.getInfo ("mods/" .. v)
            print "DUMPING " .. v
            contents, size = love.filesystem.read v
            love.filesystem.write "mods/" .. v, contents

        print "FILES DUMPED"

        writeKey "FILES_DUMPED", "1"

      if MODS_ENABLED
        export PATH_PREFIX = "mods/"
      else
        export PATH_PREFIX = ""

      export SHOW_FPS = (readKey "SHOW_FPS") == "1"

      flags = {}
      flags.fullscreen = (readKey "FULLSCREEN") == "1"
      flags.vsync = (readKey "VSYNC") == "1"
      width = tonumber (readKey "WIDTH")
      height = tonumber (readKey "HEIGHT")

      current_width, current_height, current_flags = love.window.getMode!

      num_diff = 0
      if flags.fullscreen ~= current_flags.fullscreen
        num_diff += 1
      if flags.vsync ~= current_flags.vsync
        num_diff += 1
      if width ~= current_width
        num_diff += 1
      if height ~= current_height
        num_diff += 1

      if num_diff > 0
        love.window.setMode width, height, flags

      calcScreen!

      export KEY_CHANGED = true

      --export KEY_PUSHED = false

    addObject: (object, id) =>
      --if @objects[id]
      @objects[id][#@objects[id] + 1] = object
      --else
      --  @objects[id] = {}
      --  @addObject(object, id)

    removeObject: (object, player_kill = true) =>
      found = false
      for k, v in pairs Driver.objects
        if not found
          for k2, o in pairs v
            if object == o
              if player_kill
                for k, player in pairs Driver.objects[EntityTypes.player]
                  player\onKill o

                if Driver.box_counter < Driver.max_boxes and math.random! <= o.item_drop_chance
                  Driver.box_counter += 1
                  box = ItemBoxPickUp o.position.x, o.position.y
                  Driver\addObject box, EntityTypes.item
                v[k2]\kill!
                Objectives\entityKilled v[k2]
              table.remove Driver.objects[k], k2
              found = true
              break

    clearObjects: (typeof) =>
      objects = {}
      for k, o in pairs Driver.objects[typeof]
        objects[#objects + 1] = o
      for k, o in pairs objects
        Driver\removeObject o, false

    clearAll: (excluded = {EntityTypes.player}) =>
      for k, v in pairs Driver.objects
        if not tableContains excluded, k
          Driver\clearObjects k

    killEnemies: =>
      Driver\clearObjects EntityTypes.enemy
      Driver\clearObjects EntityTypes.bullet

    respawnPlayers: =>
      for k, p in pairs Driver.objects[EntityTypes.player]
        p2 = Player Screen_Size.half_width, Screen_Size.half_height--p.position.x, p.position.y
        for k, i in pairs p.equipped_items
          if i.item_type == ItemTypes.active and i.used
            i.effect_timer = 0
            i.used = false
            i\onEnd!
          i\pickup p2
        p2.exp = p.exp
        p2.exp_lerp = p.exp_lerp
        p2.level = p.level
        Driver\removeObject p, false
        Driver\addObject p2, EntityTypes.player

    isClear: (count_enemies = true, count_bullets = true) =>
      sum = 0
      if count_enemies
        for k, v in pairs Driver.objects[EntityTypes.enemy]
          if v.alive
            sum += 1
      if count_bullets
        for k, b in pairs Driver.objects[EntityTypes.bullet]
          if b.alive
            sum += 1
      return sum == 0

    getRandomPosition: =>
      x = math.random Screen_Size.border[1], Screen_Size.border[3]
      y = math.random Screen_Size.border[2], Screen_Size.border[4]
      return Point x, y

    quitGame: ->
      ScoreTracker\disconnect!
      ScoreTracker\saveScores!
      love.event.quit 0

    keypressed: (key, scancode, isrepeat) ->
      --export KEY_PUSHED = true
      if key == "printscreen"
        screenshot = love.graphics.captureScreenshot ("screenshots/" .. os.time! .. ".png")

      if DEBUG_MENU
        if DEBUG_MENU_ENABLED
          if key == "`"
            export DEBUG_MENU = false
          else
            Debugger\keypressed key, scancode, isrepeat
      else
        if key == "`"
          if DEBUG_MENU_ENABLED
            export DEBUG_MENU = true
        elseif key == Controls.keys.PAUSE_GAME
          if Driver.game_state ~= Game_State.game_over
            if Driver.game_state == Game_State.paused
              Driver.unpause!
            else
              Driver.pause!
        else
          UI\keypressed key, scancode, isrepeat
          switch Driver.game_state
            when Game_State.playing
              if Objectives.mode.complete and key == Controls.keys.USE_TURRET
                Driver.box_counter = 0
                Objectives.ready = true
              else
                for k, v in pairs Driver.objects[EntityTypes.player]
                  v\keypressed key
            when Game_State.game_over
              GameOver\keypressed key, scancode, isrepeat

    keyreleased: (key) ->
      --pushed = false
      --for k, v in pairs Controls.keys
      --  print k, v
      --  if love.keyboard.isDown v
      --    pushed = true
      --    break
      --export KEY_PUSHED = pushed
      if DEBUG_MENU
        Debugger\keyreleased key
      else
        UI\keyreleased key
        switch Driver.game_state
          when Game_State.playing
            for k, v in pairs Driver.objects[EntityTypes.player]
              v\keyreleased key
          when Game_State.game_over
            GameOver\keyreleased key
          when Game_State.controls
            Controls\keyreleased key

    mousepressed: (x, y, button, isTouch) ->
      if DEBUG_MENU
        Debugger\mousepressed x, y, button, isTouch
      else
        UI\mousepressed x, y, button, isTouch
        switch Driver.game_state
          when Game_State.game_over
            GameOver\mousepressed x, y, button, isTouch

    mousereleased: (x, y, button, isTouch) ->
      if DEBUG_MENU
        Debugger\mousereleased x, y, button, isTouch
      else
        UI\mousereleased x, y, button, isTouch
        switch Driver.game_state
          when Game_State.game_over
            GameOver\mousereleased x, y, button, isTouch

    textinput: (text) ->
      if DEBUG_MENU
        Debugger\textinput text
      else
        UI\textinput text
        switch Driver.game_state
          when Game_State.game_over
            GameOver\textinput text

    focus: (focus) ->
      if focus
        Driver.unpause!
      else
        Driver.pause!
      UI\focus focus

    pause: ->
      Inventory\set_item!
      Driver.state_stack\add Driver.game_state
      Driver.game_state = Game_State.paused
      for k, o in pairs Driver.objects[EntityTypes.player]
        o.keys_pushed = 0
      UI.state_stack\add UI.current_screen
      UI\set_screen Screen_State.pause_menu

    unpause: ->
      Inventory\set_item!
      Driver.game_state = Driver.state_stack\remove!
      UI\set_screen UI.state_stack\remove!

    game_over: ->
      Driver.game_state = Game_State.game_over
      UI\set_screen Screen_State.game_over

    restart: ->
      loadBaseStats!

      -- Global stats
      export ScoreTracker = Score!

      -- Set love environment
      love.graphics.setDefaultFilter "nearest", "nearest", 1

      -- Global MusicHandler
      export MusicPlayer = MusicHandler!

      -- Global Renderer
      export Renderer = ObjectRenderer!

      Driver.objects = {}
      for k, v in pairs EntityTypes.layers
        Driver.objects[k] = {}
      Driver.game_state = Game_State.none
      Driver.state_stack = Stack!
      Driver.state_stack\add Game_State.main_menu
      Driver.elapsed = 0
      Driver.shader = nil
      Driver.box_counter = 0
      Driver.max_boxes = 5

      -- Global UI
      export UI = UIHandler!

      -- Debugging menu
      export Debugger = DebugMenu!

      -- Global collision checker
      export Collision = CollisionChecker!

      -- Global objectives
      export Objectives = ObjectivesHandler!

      -- Global item pool
      export ItemPool = ItemPoolHandler!

      export Controls = ControlsHandler!

      -- Create upgrade object
      export Upgrade = UpgradeScreen!

      -- Create inventory object
      export Inventory = InventoryScreen!

      -- Create pause object
      export Pause = PauseScreen!

      -- Create game over object
      export GameOver = GameOverScreen!

      ScreenCreator!

      -- Global map
      export Map = MapCreator!
      --Map\loadMap 1

      -- Create a player
      Objectives\spawn (Player), EntityTypes.player, 0, Screen_Size.half_width, Screen_Size.half_height

      -- Start game
      Objectives\nextMode!

    load: (arg) ->
      Driver.restart!

    update: (dt) ->
      --if not KEY_PUSHED
      --  return
      if DEBUG_MENU
        Debugger\update dt
      else
        Driver.elapsed += dt
        switch Driver.game_state
          when Game_State.game_over
            GameOver\update dt
          when Game_State.paused
            Pause\update dt
          when Game_State.upgrading
            Upgrade\update dt
          when Game_State.inventory
            Inventory\update dt
          when Game_State.controls
            Controls\update dt
          when Game_State.playing
            for k, v in pairs Driver.objects
              for k2, o in pairs v
                o\update dt
            Collision\update dt
            for k, v in pairs Driver.objects
              for k2, o in pairs v
                if o.health <= 0 or not o.alive
                  Driver\removeObject o
            Objectives\update dt
        UI\update dt
        ScoreTracker\update dt

        if not Driver.shader
          Driver.shader = love.graphics.newShader "shaders/normal.fs"

    draw: ->
      love.graphics.push "all"
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
        love.graphics.setShader Driver.shader
      setColor 75, 163, 255, 255
      love.graphics.rectangle "fill", 0, 0, Screen_Size.width, Screen_Size.height
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
        love.graphics.setShader!
      love.graphics.pop!
      love.graphics.push "all"
      UI\draw!
      switch Driver.game_state
        when Game_State.playing
          love.graphics.push "all"
          setColor 15, 87, 132, 200
          bounds = Screen_Size.border
          love.graphics.rectangle "fill", 0, 0, bounds[3], bounds[2]
          love.graphics.rectangle "fill", 0, bounds[2] + bounds[4], bounds[3], bounds[2]
          love.graphics.pop!

          font = Renderer\newFont 30
          love.graphics.setFont font
          setColor 0, 0, 0, 255
          love.graphics.printf ScoreTracker.score, 0, (20 * Scale.width) - (font\getHeight! / 2), Screen_Size.width - (10 * Scale.width), "right"
          Renderer\drawAll!
          Objectives\draw!

          if DEBUGGING
            y = 100
            for k, layer in pairs EntityTypes.order
              message = layer .. ": " .. #Driver.objects[layer]
              font = Renderer\newFont 20
              Renderer\drawAlignedMessage message, y, "left", font, (Color 255, 255, 255)
              y += 25
        when Game_State.upgrading
          Upgrade\draw!
          UI\draw {TooltipBox}
        when Game_State.inventory
          Inventory\draw!
        when Game_State.controls
          Controls\draw!
        when Game_State.paused
          Pause\draw!
        when Game_State.game_over
          GameOver\draw!
      setColor 0, 0, 0, 127
      love.graphics.setFont (Renderer\newFont 20)
      love.graphics.printf VERSION, 0, Screen_Size.height - (25 * Scale.height), Screen_Size.width - (10 * Scale.width), "right"
      if SHOW_FPS
        love.graphics.printf love.timer.getFPS! .. " FPS", 0, Screen_Size.height - (50 * Scale.height), Screen_Size.width - (10 * Scale.width), "right"
      love.graphics.pop!

      if DEBUG_MENU
        Debugger\draw!

      collectgarbage "step"
