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

      if not love.filesystem.exists "SETTINGS"
        love.filesystem.write "SETTINGS", "MODS_ENABLED 0"

      MODS_ENABLED = readKey "MODS_ENABLED"
      FILES_DUMPED = readKey "FILES_DUMPED"

      if MODS_ENABLED and not FILES_DUMPED
        print "DUMPING FILES"

        dirs = getAllDirectories "assets"
        for k, v in pairs dirs
          love.filesystem.createDirectory "mods/" .. v

        files = getAllFiles "assets"
        for k, v in pairs files
          if not love.filesystem.exists "mods/" .. v
            print "DUMPING " .. v
            contents, size = love.filesystem.read v
            love.filesystem.write "mods/" .. v, contents

        print "FILES DUMPED"

        writeKey "FILES_DUMPED", "1"

      if MODS_ENABLED
        export PATH_PREFIX = "mods/"
      else
        export PATH_PREFIX = ""

    addObject: (object, id) =>
      if @objects[id]
        @objects[id][#@objects[id] + 1] = object
        Renderer\add object, EntityTypes.layers[id]
      else
        @objects[id] = {}
        @addObject(object, id)

    removeObject: (object, player_kill = true) =>
      found = false
      for k, v in pairs Driver.objects
        if not found
          for k2, o in pairs v
            if object == o
              Renderer\removeObject object
              if player_kill
                if math.random! <= o.item_drop_chance
                  box = ItemBox o.position.x, o.position.y
                  Driver\addObject box, EntityTypes.item
                v[k2]\kill!
                Objectives\entityKilled v[k2]
              table.remove Driver.objects[k], k2
              found = true
              break

    clearObjects: (typeof) =>
      if Driver.objects[typeof]
        objects = {}
        for k, o in pairs Driver.objects[typeof]
          objects[#objects + 1] = o
        for k, o in pairs objects
          Driver\removeObject o, false

    killEnemies: =>
      Driver\clearObjects EntityTypes.enemy
      Driver\clearObjects EntityTypes.bullet

    respawnPlayers: =>
      if Driver.objects[EntityTypes.player]
        for k, p in pairs Driver.objects[EntityTypes.player]
          p2 = Player p.position.x, p.position.y
          for k, i in pairs p.equipped_items
            i\pickup p2
          Driver\removeObject p, false
          Driver\addObject p2, EntityTypes.player

    isClear: =>
      sum = 0
      if Driver.objects[EntityTypes.enemy]
        for k, v in pairs Driver.objects[EntityTypes.enemy]
          if v.alive
            sum += 1
      if Driver.objects[EntityTypes.bulet]
        for k, b in pairs Driver.objects[EntityTypes.bullet]
          if b.alive
            sum += 1
      return sum == 0

    getRandomPosition: =>
      x = math.random Screen_Size.border[1], Screen_Size.border[3]
      y = math.random Screen_Size.border[2], Screen_Size.border[4]
      return Point x, y

    keypressed: (key, scancode, isrepeat) ->
      if key == "escape"
        love.event.quit 0
      elseif key == "printscreen"
        screenshot = love.graphics.newScreenshot true
        screenshot\encode "png", "screenshots/" .. os.time! .. ".png"

      if DEBUG_MENU
        if key == "`"
          export DEBUG_MENU = false
        else
          Debugger\keypressed key, scancode, isrepeat
      else
        if key == "`"
          export DEBUG_MENU = true
        elseif key == "p"
          if Driver.game_state == Game_State.paused
            Driver.unpause!
          else
            Driver.pause!
        else
          if Driver.game_state == Game_State.playing
            if Objectives.mode.complete and key == "space"
              Objectives.ready = true
            else
              for k, v in pairs Driver.objects[EntityTypes.player]
                v\keypressed key

    keyreleased: (key) ->
      if DEBUG_MENU
        Debugger\keyreleased key
      else
        if Driver.game_state == Game_State.playing
          for k, v in pairs Driver.objects[EntityTypes.player]
            v\keyreleased key

    mousepressed: (x, y, button, isTouch) ->
      if DEBUG_MENU
        Debugger\mousepressed x, y, button, isTouch
      else
        UI\mousepressed x, y, button, isTouch

    mousereleased: (x, y, button, isTouch) ->
      if DEBUG_MENU
        Debugger\mousereleased x, y, button, isTouch
      else
        UI\mousereleased x, y, button, isTouch

    textinput: (text) ->
      if DEBUG_MENU
        Debugger\textinput text
      else
        UI\textinput text

    focus: (focus) ->
      if focus
        Driver.unpause!
      else
        Driver.pause!
      UI\focus focus

    pause: ->
      Inventory\set_message!
      Driver.state_stack\add Driver.game_state
      Driver.game_state = Game_State.paused
      for k, o in pairs Driver.objects[EntityTypes.player]
        o.keys_pushed = 0
      UI.state_stack\add UI.current_screen
      UI\set_screen Screen_State.pause_menu

    unpause: ->
      Inventory\set_message!
      Driver.game_state = Driver.state_stack\remove!
      UI\set_screen UI.state_stack\remove!

    game_over: ->
      Driver.game_state = Game_State.game_over
      UI\set_screen Screen_State.game_over

    restart: ->
      loadBaseStats!

      -- Global stats
      export SCORE = 0
      export SCORE_THRESHOLD = 10000

      -- Set love environment
      love.graphics.setDefaultFilter "nearest", "nearest", 1

      -- Global MusicHandler
      export MusicPlayer = MusicHandler!

      -- Global Renderer
      export Renderer = ObjectRenderer!

      Driver.objects = {}
      Driver.game_state = Game_State.none
      Driver.state_stack = Stack!
      Driver.state_stack\add Game_State.main_menu
      Driver.elapsed = 0
      Driver.shader = nil

      -- Global UI
      export UI = UIHandler!

      -- Debugging menu
      export Debugger = DebugMenu!

      -- Global objectives
      export Objectives = ObjectivesHandler!

      -- Global item pool
      export ItemPool = ItemPoolHandler!

      -- Create upgrade object
      export Upgrade = UpgradeScreen!

      -- Create inventory object
      export Inventory = InventoryScreen!

      -- Create pause object
      export Pause = PauseScreen!

      ScreenCreator!

      -- Global map
      export Map = MapCreator!
      --Map\loadMap 1

      -- Create a player
      Objectives\spawn EntityTypes.player, 0, love.graphics.getWidth! / 2, love.graphics.getHeight! / 2

      -- Start game
      Objectives\nextMode!

    load: (arg) ->
      Driver.restart!

    update: (dt) ->
      if DEBUG_MENU
        Debugger\update dt
      else
        Driver.elapsed += dt
        switch Driver.game_state
          when Game_State.game_over
            return
          when Game_State.paused
            Pause\update dt
          when Game_State.upgrading
            Upgrade\update dt
          when Game_State.inventory
            Inventory\update dt
          when Game_State.playing
            for k, v in pairs Driver.objects
              for k2, o in pairs v
                o\update dt
                if o.health <= 0 or not o.alive
                  Driver\removeObject o
            Objectives\update dt
        UI\update dt

        if not Driver.shader
          Driver.shader = love.graphics.newShader "shaders/normal.fs"

    draw: ->
      love.graphics.push "all"
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
        love.graphics.setShader Driver.shader
      love.graphics.setColor 75, 163, 255, 255
      love.graphics.rectangle "fill", 0, 0, Screen_Size.width, Screen_Size.height
      if Driver.game_state == Game_State.playing or UI.current_screen == Screen_State.none
        love.graphics.setShader!
      love.graphics.pop!
      love.graphics.push "all"
      UI\draw!
      switch Driver.game_state
        when Game_State.playing
          love.graphics.push "all"
          love.graphics.setColor 15, 87, 132, 200
          bounds = Screen_Size.border
          love.graphics.rectangle "fill", 0, 0, bounds[3], bounds[2]
          love.graphics.rectangle "fill", 0, bounds[2] + bounds[4], bounds[3], bounds[2]
          love.graphics.pop!

          Renderer\drawAlignedMessage SCORE .. "\t", 20 * Scale.height, "right", Renderer.hud_font
          Renderer\drawAll!
          Objectives\draw!
        when Game_State.upgrading
          Upgrade\draw!
        when Game_State.inventory
          Inventory\draw!
        when Game_State.paused
          Pause\draw!
      love.graphics.setColor 0, 0, 0, 127
      love.graphics.setFont Renderer.small_font
      love.graphics.printf VERSION .. "\t", 0, Screen_Size.height - (25 * Scale.height), Screen_Size.width, "right"
      love.graphics.printf love.timer.getFPS! .. " FPS\t", 0, Screen_Size.height - (50 * Scale.height), Screen_Size.width, "right"
      love.graphics.pop!

      if DEBUG_MENU
        Debugger\draw!

      collectgarbage "step"
